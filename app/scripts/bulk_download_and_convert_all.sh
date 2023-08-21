#!/bin/sh

cat <<EOS

Fileyear? (ex. 2021)
YYYY の形式で入力してください。
EOS

read FILEYEAR

FILETYPES=("Ukc" "Ks" "Bac" "Kta" "Kyi" "Sed")

for FILETYPE in "${FILETYPES[@]}"; do
sh ../downloader/bulk_downloader.sh << EOS
${FILETYPE}
${FILEYEAR}
EOS

sh ../converter/bulk_converter.sh << EOS
${FILETYPE}
${FILEYEAR}
EOS

ruby ../upserter/bulk_upserter.rb ${FILETYPE}

done

rm -rf ${DOWNLOAD_FILE_OUTPUT_DIRECTORY}
rm -rf ${CONVERT_FILE_OUTPUT_DIRECTORY}
