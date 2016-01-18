#!/bin/bash
# Translate text with Yandex API
text=`xclip -o`
translate=en-ru
  wget -O -  https://translate.yandex.net/api/v1.5/tr.json/translate --post-data="key=trnsl.1.1.20160117T231050Z.2d9e215cfc85a1fd.e529754def6a2c685b8efd67755bf1d4e82244de&lang=${translate}&text=${text}" | grep -o -e "\[.\+\]"| xargs  notify-send 

