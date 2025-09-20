#!/bin/bash

echo "WebP to MP4 変換に必要なツールをチェックしています..."
echo "----------------------------------------"

# 必要なコマンドリスト
commands=("convert" "ffmpeg")
packages=("imagemagick" "ffmpeg")
webp_packages=("libwebp-dev" "webp")

missing_commands=()
missing_packages=()

# 各コマンドの存在を確認
for i in "${!commands[@]}"; do
    command=${commands[$i]}
    package=${packages[$i]}
    
    echo -n "$command (${package})をチェック中... "
    if command -v "$command" &> /dev/null; then
        echo "インストール済み"
    else
        echo "見つかりません"
        missing_commands+=("$command")
        missing_packages+=("$package")
    fi
done

# WebP形式がサポートされているか確認
echo -n "ImageMagickでのWebPサポートをチェック中... "
if command -v convert &> /dev/null; then
    if convert -list format | grep -i webp &> /dev/null; then
        echo "サポート済み"
    else
        echo "WebPサポートが見つかりません"
        missing_packages+=("${webp_packages[@]}")
    fi
fi

# ImageMagickのポリシー設定をチェック
echo -n "ImageMagickのWebPポリシー設定をチェック中... "
if command -v convert &> /dev/null; then
    policy_files=("/etc/ImageMagick-6/policy.xml" "/etc/ImageMagick-7/policy.xml" "/etc/ImageMagick/policy.xml")
    policy_restricted=false
    
    for policy_file in "${policy_files[@]}"; do
        if [ -f "$policy_file" ]; then
            if grep -q '<policy domain="coder" rights="none" pattern="WEBP"' "$policy_file"; then
                policy_restricted=true
                echo "WebP制限が見つかりました（$policy_file）"
                break
            fi
        fi
    done
    
    if [ "$policy_restricted" = false ]; then
        echo "問題なし"
    fi
else
    echo "ImageMagickがインストールされていないためスキップ"
fi

echo "----------------------------------------"

# 結果の表示
if [ ${#missing_commands[@]} -eq 0 ] && [ "$policy_restricted" = false ]; then
    echo "すべての必要条件が満たされています！webp2mp4.shを実行できます。"
else
    echo "以下のパッケージをインストールする必要があります："
    
    if [ ${#missing_packages[@]} -gt 0 ]; then
        unique_packages=($(echo "${missing_packages[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '))
        echo "sudo apt update"
        echo "sudo apt install -y ${unique_packages[*]}"
    fi
    
    if [ "$policy_restricted" = true ]; then
        echo ""
        echo "また、ImageMagickのWebP制限を解除する必要があります："
        echo "該当するポリシーファイル（上記で見つかったもの）を編集し、"
        echo "  <policy domain=\"coder\" rights=\"none\" pattern=\"WEBP\" />"
        echo "を以下のように変更してください："
        echo "  <policy domain=\"coder\" rights=\"read|write\" pattern=\"WEBP\" />"
        echo ""
        echo "例："
        echo "sudo nano $policy_file"
    fi
fi

# サンプルWebPファイルの作成方法も表示
echo ""
echo "テスト用にサンプルのアニメーションWebPファイルが必要な場合："
echo "1. GIFやPNGシーケンスからWebPを作成するには："
echo "   ffmpeg -i animated.gif -c:v libwebp -lossless 1 -q:v 60 -loop 0 -preset picture -an -vsync 0 output.webp"
echo ""
echo "2. インターネットからサンプルをダウンロードするには："
echo "   wget https://upload.wikimedia.org/wikipedia/commons/1/14/Animated_WebP_sample.webp"