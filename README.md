# Animated WebP Utils

アニメーションWebPファイルをMP4に変換するためのユーティリティスクリプト集です。

## 機能

- アニメーションWebPファイルをGIFに変換
- 複数のGIFファイルを1つのMP4ビデオに結合
- 必要な依存パッケージのチェック

## 必要条件

- Ubuntu または Debian ベースの Linux ディストリビューション
- ImageMagick (WebP対応)
- FFmpeg

## インストール

リポジトリをクローンします：

```bash
git clone https://github.com/daichan4649/animated-webp-utils.git
cd animated-webp-utils
chmod +x *.sh
```

## 使い方

### 1. 必要条件のチェック

まず、必要なツールがインストールされているかチェックします：

```bash
./check_requirements.sh
```

不足しているパッケージがある場合は、表示される指示に従ってインストールしてください。

### 2. アニメーションWebPをMP4に変換

WebPファイルが含まれているディレクトリを指定して実行します：

```bash
./webp2mp4.sh [WebPファイルが含まれているディレクトリのパス]
```

例：

```bash
./webp2mp4.sh ~/Downloads/animated_webp
```

変換が完了すると、指定したディレクトリに `output.mp4` が作成されます。

## 仕組み

1. `webp2mp4.sh` は以下の手順で変換を行います：
   - ImageMagickを使用して、各WebPファイルをGIFに変換
   - 変換されたGIFファイルのリストを作成
   - FFmpegを使用して、GIFファイルを結合し、単一のMP4ファイルに変換

2. `check_requirements.sh` は以下の内容をチェックします：
   - ImageMagickとFFmpegがインストールされているか
   - ImageMagickがWebP形式をサポートしているか
   - ImageMagickのポリシー設定でWebPが制限されていないか

## トラブルシューティング

### ImageMagickのポリシー制限

セキュリティ上の理由から、一部のUbuntuバージョンではImageMagickのWebP変換が制限されています。この場合、以下のコマンドでポリシー設定を変更してください：

```bash
sudo nano /etc/ImageMagick-6/policy.xml
```

以下の行を探して：
```xml
<policy domain="coder" rights="none" pattern="WEBP" />
```

次のように変更：
```xml
<policy domain="coder" rights="read|write" pattern="WEBP" />
```

### サンプルWebPファイルの作成

テスト用にアニメーションWebPファイルが必要な場合：

1. GIFからWebPを作成：

```bash
ffmpeg -i animated.gif -c:v libwebp -lossless 1 -q:v 60 -loop 0 -preset picture -an -vsync 0 output.webp
```

2. サンプルのダウンロード：

```bash
wget https://upload.wikimedia.org/wikipedia/commons/1/14/Animated_WebP_sample.webp
```

## ライセンス

MIT