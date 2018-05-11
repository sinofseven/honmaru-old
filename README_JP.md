# Honmaru (JP)

CloudFormation用のCLI Toolです。
SAM用Serverless Frameworkを目指していますが、現在実装できているのはCloudFormationのStack Eventを監視/表示する"listem"コマンドだけです。  
今後CloudFormationのCreate/Update/Delete Stackを行えるようにしたり、SAM関係の機能を実装したりしていきます。

## インストール

    $ gem install honmaru

## 使い方

```bash
$ AWS_PROFILE=xxxxxx AWS_REGION=xxxxxx honmaru [COMMAND] [OPTIONS]
```

## Commands

### list
- listen : CloudFormationのStack Eventの監視/表示を行う

### listen

CloudFormationのCreate/Update/Delete Stackの完了まで、Stacke Eventを取得しながら、待機する。
完了時、FAILEDしたリソースがあれば表示する。
```-v```オプションを使用することでStack Eventを表示する。

Options

- ```--stack-name [stack_name]```: 
  - [Required]
  - CloudFormationのスタック名
- ```--only-once```:
  - オプション指定時Stack Eventの取得を一度しか行わない。
- ```--disable-auto-stop```: 
  - CloudFormationでのデプロイと削除の完了時に自動的にイベントの取得を終了させない
- ```--interval [N]```: 
  - イベントの取得の間隔をN秒にする。
  - default: 5秒
- ```--client-request-token [token]```: 
  - ClientRequestTokenが指定したものと一致するStack Eventのみ表示する
    - ClientRequestTokenはCloudFormationのデプロイ/削除時に指定するもの
- ```-v (--verbose)```:
  - Stack Eventを表示する
- ```--is-delete```:
  - Delete Stack時に指定する
  - (auto stopに使用しているため、```--only-once```を指定しているときは必要ない)

## 今後の予定
以下の機能の実装を予定している
- [ ] AWSのProfileとRegionをコマンドのオプションで指定できるようにする
- [ ] CloudFormationのCreate/Update/Delete Stackの実装
- [ ] ```aws cloudformation package```の実装
- [ ] SAM用のLambdaデプロイパッケージの作成
  - [ ] node.js
    - [ ] npm
    - [ ] yarn
  - [ ] python
    - [ ] pipenv
    - [ ] requirements.txt 
- [ ] SAM用のLambdaデプロイパッケージをDockerを使用して作成する
- [ ] オプションをファイルでも指定できるようにする (ex. serverless.yml, Dockerfile, Makefile)

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
