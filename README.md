# EngCooker

EngCooker は英文の穴埋め問題を作成し、出題するCUIツールです。

# Requirements

- >= Ruby 2.1

# Setup

依存するGemをインストールします。

```
$ bundle install
```

config/application.example.rbをconfig/application.rbにコピーします。

```
$ cp config/application.example.rb config/application.rb
```

以上。

# Create questions

問題を出題する前に、英文とその訳文を登録しなければいけません。英文と訳文の登録は、下記のコマンドで行えます。

```
$ bin/eng_cooker make
```

`English text: ` という表示の後に、英文を入力します。`Japanese text: `という表示の後に、訳文を入力します。

入力後、`Maked success.` と表示されれば、登録成功です。

# Set a question

問題の出題は、下記のコマンドで行えます。

```
$ bin/eng_cooker question
```

登録済みの英文の中からランダムで1つが選ばれ、問題が出題されます。

```
彼女は海岸で貝殻を売ります。
> ___ _____ _________ __ ___ ________.
```

訳文に対する英文を入力します。

```
> She sells saeshells by the saeshore.[Enter]
```

正解した場合は、ツールは閉じられます。誤っていた場合は、誤った部分だけを隠した英文が表示されます。

```
彼女は海岸で貝殻を売ります。
> She sells s__shells by the s__shore.
```

正解するまで、繰り返し回答できます。途中で辞めたいときは`Ctrl+C`を押して、ツールを強制終了してください。

