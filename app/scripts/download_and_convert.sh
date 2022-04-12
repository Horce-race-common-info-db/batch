#!/bin/sh

# TODO: 日付の設定は運用に乗ってから考える
# ローカル環境では引数として日付を受け取って、テスト用にデータを取得できるようにする。
FILEDATE=$1

sh ../downloader/download_all.sh << EOS
${FILEDATE}
EOS

sh ../converter/convert_all.sh << EOS
${FILEDATE}
EOS