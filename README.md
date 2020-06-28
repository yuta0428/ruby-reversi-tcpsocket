# Creating a reversi using Ruby's TCPSocket

これはRubyで作ったリバーシです。

TCPSocketを使用して、クライアント・サーバ型の通信方式で対戦を行うことができます。

RSpecを使用したテストも追加しています。

**Versions**
- Ruby 2.6.3
- bundler 1.17.2

## How to use
You need to launch it from the server.

#### Server
```
bundle exec ruby app/app.rb server
```

#### Client
```
bundle exec ruby app/app.rb client
```

![](asset/how-to-use.gif)

## System

### Main Game Loop
メインのゲームループは下記で行っています
- [app/systems/server.rb](app/systems/server.rb)
- [app/systems/client.rb](app/systems/client.rb)

流れは、
1. serverを立ち上げ、
2. clientからの接続要求を受け入れ(*JoinRequest*)
3. 規定人数が揃ったらゲーム開始(*GameStartNotify*)
4. ターン開始時に自ターンかどうか判別する(*TurnStartNotify*)
5. 自ターンなら打つ箇所を入力(PutPieceRequest)
6. レスポンス結果から置けたならならターン終了、置けない箇所なら再度入力(*PutPieceResponse*)
7. ターン終了時に現在の盤面情報とゲームが終了したかが送られる(*TurnEndNotify*)
8. ゲーム終了してなければ4に戻る
9. ゲーム終了時、結果を受け取って勝敗を表示(*GameFinishNotify*)

**clientは打つ箇所の指定と受け取った盤面情報の表示しかせず、リバーシのロジックは全てserverが担っています。**

### TCPSocket
通信に扱うリクエスト周りは、
- [app/systems/request.rb](app/systems/request.rb)

通信処理自体は、
- [app/systems/rocket.rb](app/systems/rocket.rb)
- [app/systems/rocket_service.rb](app/systems/rocket_service.rb)

*Rocket*クラスは、*socket*ライブラリの[TCPSocket](https://docs.ruby-lang.org/ja/2.6.0/class/TCPSocket.html)をラップしたクラスです。

*RocketService*モジュールは、内部で*RocketSender*クラスと*RocketReceiver*クラスに分かれています。

下記どちらの形式でにも対応できるよう
- clientからのserverへリクエストを送る、serverはそれを受け取る
- serverからclientへリクエストを送る、clientをそれを受け取る

送る際はR*ocketSender*、受け取る際は*RocketReceiver*を使うことで、内部的に判別してStructをmessageへ、messageをStructへ変換しています。

## Dependency gems
- https://github.com/rspec/rspec
