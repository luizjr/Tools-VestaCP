#! /bin/bash
#created luizjrdeveloper@gmail.com
#author Luiz Jr
#created 10/03/2018

a="FILEMANAGER_KEY=''"
b="FILEMANAGER_KEY='ILOVEREO'"

if grep -Fxq "$a" /usr/local/vesta/conf/vesta.conf
then
# code if found
sed -i -e "s/$a/$b/g" /usr/local/vesta/conf/vesta.conf

fi
