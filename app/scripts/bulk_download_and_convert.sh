#!/bin/sh

cat <<EOS

Filetype? (ex. Ukc)

以下のファイルタイプが選択できます。
===================================
JRDB 騎手データ  : Ks
JRDB 番組データ  : Bac
JRDB 登録馬データ: Kta
JRDB 馬基本データ: Ukc
JRDB 競争馬データ: Kyi
JRDB 成績データ  : Sed 
===================================
EOS

read FILETYPE

cat <<EOS

Fileyear? (ex. 2021)
YYYY の形式で入力してください。
EOS

read FILEYEAR

sh ../downloader/bulk_downloader.sh << EOS
${FILETYPE}
${FILEYEAR}
EOS

sh ../converter/bulk_converter.sh << EOS
${FILETYPE}
${FILEYEAR}
EOS

ruby ../upserter/bulk_upserter.rb ${FILETYPE}

rm -rf ${DOWNLOAD_FILE_OUTPUT_DIRECTORY}
rm -rf ${CONVERT_FILE_OUTPUT_DIRECTORY}
