#!/bin/bash

# Check if input directory is provided
if [ -z "$1" ]; then
  echo "使用法: $0 [入力ディレクトリパス]"
  exit 1
fi

# Check if input directory exists
if [ ! -d "$1" ]; then
  echo "エラー: ディレクトリ '$1' は存在しません"
  exit 1
fi

# Change to the input directory
cd "$1" || exit 1

echo "ディレクトリ内のWebPファイルを処理しています: $1"

# Check if any webp files exist
if ! ls *.webp >/dev/null 2>&1; then
  echo "ディレクトリ内にWebPファイルが見つかりません"
  exit 1
fi

echo "WebPファイルをGIFに変換しています..."

# Convert animated WebP files to GIF
for webp in *.webp; do
  filename=$(basename "$webp" .webp)
  echo "$webp を $filename.gif に変換しています..."
  convert "$webp" -coalesce "$filename.gif"
done

echo "GIFファイルのリストを作成しています..."

# Create a list of GIF files
ls -v *.gif | sed 's/^/file /' > gif_list.txt

echo "GIFを結合してMP4に変換しています..."

# Combine GIFs and convert to MP4
ffmpeg -f concat -safe 0 -i gif_list.txt -c:v libx264 -pix_fmt yuv420p -movflags +faststart output.mp4

echo "変換完了！出力ファイル: $1/output.mp4"