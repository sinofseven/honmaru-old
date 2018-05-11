module Honmaru
  class Listen
    def initialize(opt, cfn)
      @stack_name = opt['stack-name']
      @only_once = opt['only-once']
      @disable_auto_stop = opt['disable-auto-stop']
      @interval = opt['interval']
      @client_request_token = opt['client-request-token']
      @cfn = cfn
      @pastel = Pastel.new
      @verbose = opt['verbose']
      @is_delete = opt['is-delete']
      start_expression
      repeat
    end

    private

    def start_expression
      honmaru = @pastel.yellow('honmaru')
      puts "#{honmaru} : start listening"
      return unless @verbose
      puts "#{honmaru} :   stack-name = #{@stack_name}"
      puts "#{honmaru} :   only-once = #{@only_once}"
      puts "#{honmaru} :   disable-auto-stop = #{@disable_auto_stop}"
      puts "#{honmaru} :   interval = #{@interval}"
      puts "#{honmaru} :   client-request-token = #{@client_request_token.nil? ? 'null' : "\"#{@client_request_token}\""}"
      puts "#{honmaru} :   is-delete = #{@is_delete}"
      puts "#{honmaru} :   verbose = #{@verbose}"
    end

    def colored_event_text(event)
      status = @pastel.yellow(event.resource_status)
      if !(event.resource_status =~ /FAILED$/).nil?
        status = @pastel.red(event.resource_status)
      elsif !(event.resource_status =~ /COMPLETE$/).nil?
        status = @pastel.green(event.resource_status)
      end
      "CloudFormation - #{status} - #{event.resource_type} - #{event.logical_resource_id}"
    end

    def get_events(next_token: nil)
      opt = {
        stack_name: @stack_name
      }
      opt['next_token'] = next_token unless next_token.nil?
      resp = @cfn.describe_stack_events(opt)
      resp.stack_events
    end

    def output_err(list)
      return unless list.class == [].class
      return if list.empty?
      puts ''
      puts @pastel.red('====== ERRORS ======')
      list.each do |event|
        puts ''
        puts "  #{event.logical_resource_id}"
        puts "    #{event.resource_status_reason}"
      end
    end

    def repeat
      last_event = nil
      errors = []
      f_first = false
      loop do
        begin
          sleep @interval if f_first
          f_first ||= true
          f_auto_stop = false
          events = []
          begin
            events = get_events
          rescue Aws::CloudFormation::Errors::ValidationError => e
            if @is_delete
              break unless (e.message =~ /does not exist$/).nil?
            end
            raise e
          end
          events = events.select { |i| i.client_request_token == @client_request_token } unless @client_request_token.nil?
          unless events.empty?
            f_latest = last_event.nil?
            events.reverse.each do |event|
              unless f_latest
                f_latest = true if last_event.event_id == event.event_id
                next
              end
              last_event = event
              errors << event unless (event.resource_status =~ /FAILED$/).nil?
              puts colored_event_text(event) if @verbose
            end
            unless @disable_auto_stop
              if last_event.resource_type == 'AWS::CloudFormation::Stack' &&
                 !(last_event.resource_status =~ /COMPLETE$/).nil? &&
                 (last_event.timestamp - Time.now).abs < @interval * 3
                f_auto_stop = true
              end
            end
          end
          break if @only_once
          break if f_auto_stop
        rescue Interrupt
          puts ''
          puts 'Interrupted by Ctr+C'
          break
        end
      end
      output_err(errors)
    end
  end
end
