#!/bin/bash
FILE_NAME=$1

encoding() {
END_OF_CARD="END:VCARD"
LINE=$(grep -m 1 -o -n ${END_OF_CARD} ${FILE_NAME}| grep -o -E "^[0-9]")
NAME=$(grep -m 1 "QUOTED" ${FILE_NAME})
TEL=$(grep -m 1 "TEL" ${FILE_NAME}| grep -m 1 -o -E "([0-9]{0,25})")
NAME_LINE=$(grep -n -m 1 "QUOTED" ${FILE_NAME} | grep -o -E "^[0-9]")
NEXT_NAME_LINE=$(sed -n $((NAME_LINE+1))p ${FILE_NAME})
FIRST_CHAR=$(echo ${NEXT_NAME_LINE} | cut -c 1)
#echo ${FIRST_CHAR}
#LINE = line number with END_OF_CARD - border of one contact
#echo ${LINE}
#NAME_LINE = line number with hex 
#echo ${NAME_LINE}
#NEXT_NAME_LINE = var with next line after NAME_LINE. In case of name hex
#consist with few lines
#echo ${NEXT_NAME_LINE}
#NAME - var with string, that contains first hex with name
#echo ${NAME}
#TEL - var with first TEL
#echo ${TEL}
EQUOL_POSITION=$(echo "${NAME}" | grep -aob '=') 
#EQUOL_POSITION - start hex position in string
#echo ${EQUOL_POSITION}
MY_EQUOL_POSITION=$(echo ${EQUOL_POSITION} | awk '{print $3}' | grep -o -E "[0-9]{0,5}")
#echo ${MY_EQUOL_POSITION}
SIZE=${#NAME}
NAME_CLEAR=$(echo "${NAME}" | cut -c $((MY_EQUOL_POSITION+1))-${SIZE})
echo ${NAME_CLEAR}
echo ${NEXT_NAME_LINE}
if [ ${FIRST_CHAR} != "T" ]
 then
   NAME_CLEAR+=${NEXT_NAME_LINE}
else
   NAME_CLEAR=${NAME_CLEAR}
fi
echo ${NAME_CLEAR} > 1.txt
echo ${NAME_CLEAR}
ENCODED_NAME=$(qprint -d 1.txt)
echo ${ENCODED_NAME}
echo -e "${ENCODED_NAME}: ${TEL}" >> phonebook.txt
sed -i "1,${LINE}d" ${FILE_NAME}
}


while [ $? -ne "1" ]; do
        encoding
done

sed -i "s/;/ /" phonebook.txt
sort -u phonebook.txt > phones.txt
