#!/usr/bin/env bash
tf_keyword=':~:text='

echo "start $0"
echo "POPCLIP_TEXT: ${POPCLIP_TEXT}"

encoded_text=$(php -r "echo urlencode('$POPCLIP_TEXT');")
echo "encoded_text: ${encoded_text}"

target_url=$(./get-current-url-on-chrome.scpt)
echo "target_url: ${target_url}"

if [[ "${target_url}" =~ .*#.*${tf_keyword} ]]
then
  target_url="${target_url/${tf_keyword}*/}"
fi

if [[ "${target_url}" != *'#'* ]]
then
  target_url="${target_url}#"
fi

target_url="${target_url}${tf_keyword}${encoded_text}"
echo "target_url with text fragment: ${target_url}"

open -b com.google.Chrome "${target_url}"
