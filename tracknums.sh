for file in *.mp3; do mv "$file" "`id3v2 -l "$file" | grep TRCK | sed -e 's/.*:\ \(..\)\/.*$/\1/'`.$file"; done
