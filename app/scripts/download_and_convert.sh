#!/bin/sh

cat <<EOS

Filedate? (ex. 220319)
yymmdd の形式で入力してください。
EOS

read FILEDATE

sh ../downloader/download_all.sh << EOS
${FILEDATE}
EOS

sh ../converter/convert_all.sh << EOS
${FILEDATE}
EOS

ruby ../upserter/upsert.rb ${FILEDATE}

rm -rf ${DOWNLOAD_FILE_OUTPUT_DIRECTORY}
rm -rf ${CONVERT_FILE_OUTPUT_DIRECTORY}
