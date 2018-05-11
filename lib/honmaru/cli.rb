module Honmaru
  class CLI < Thor
    desc 'listen', 'listening CFn stack events'
    option '--stack-name', type: :string, required: true
    option '--only-once', type: :boolean, default: false
    option '--disable-auto-stop', type: :boolean, default: false
    option '--interval', type: :numeric, default: 5
    option '--client-request-token', type: :string
    option '--verbose', aliases: '-v', type: :boolean, default: false
    option '--is-delete', type: :boolean, default: false
    def listen
      opt = options.to_hash
      c_listen(opt)
    end

    private

    def make_cfn
      cfn = Aws::CloudFormation::Client.new
      cfn
    end

    def c_listen(opt)
      cfn = make_cfn
      Honmaru::Listen.new(opt, cfn)
    end
  end
end
