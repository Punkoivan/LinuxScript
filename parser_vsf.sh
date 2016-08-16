#!/bin/bash
FILE_NAME=$1

encoding() {
END_OF_CARD="END:VCARD"
LINE=$(grep -m 1 -o -n ${END_OF_CARD} ${FILE_NAME}| grep -o -E "^[0-9]")
NAME=$(grep -m 1 "QUOTED" ${FILE_NAME})
TEL=$(grep -m 1 "TEL" ${FILE_NAME}| grep -m 1 -o -E "([0-9]{0,25})")
echo ${LINE}
echo ${NAME}
echo ${TEL}
EQUOL_POSITION=$(echo "${NAME}" | grep -aob '=') 
echo ${EQUOL_POSITION}
MY_EQUOL_POSITION=$(echo ${EQUOL_POSITION} | awk '{print $3}' | grep -o -E "[0-9]{0,5}")
echo ${MY_EQUOL_POSITION}
SIZE=${#NAME}
NAME_CLEAR=$(echo "${NAME}" | cut -c $((MY_EQUOL_POSITION+1))-${SIZE})
echo ${NAME_CLEAR} > 1.txt
ENCODED_NAME=$(qprint -d 1.txt)
echo ${ENCODED_NAME}
echo -e "${ENCODED_NAME}: ${TEL}" >> phonebook.txt
sed -i "1,${LINE}d" ${FILE_NAME}
}

encoding
