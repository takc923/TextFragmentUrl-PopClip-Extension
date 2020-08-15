echo "start $0"
echo "POPCLIP_TEXT: ${POPCLIP_TEXT}"

encoded_text=$(php -r "echo urlencode('$POPCLIP_TEXT');")
echo "encoded_text: ${encoded_text}"

target_url=$(./get-current-url-on-chrome.scpt)
echo "target_url: ${target_url}"

if [[ "$target_url" == *'#'* ]]
then
  if [[ "$target_url" == *':~:text='* ]]
  then
    target_url="${target_url/:~:text=*/}"
  fi
else
  target_url="${target_url}#"
fi

target_url="${target_url}:~:text=${encoded_text}"
echo "target_url with text fragment: ${target_url}"

open -b com.google.Chrome "${target_url}"
