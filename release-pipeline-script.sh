#!/bin/bash
input=version-list.txt
echo "input file" $input
myyear=`date +'%y'`
week=$(date +%V)
version=Rel_${myyear}.${week}
echo "version" $version
while IFS= read -r var
do
echo $var $version
REL_VER_EXIST=false
if [[ "$var" =~ ^$version.*  ]]; then
    echo "exist"
    echo "VERSION" $version
    awk -v s="$version" 'index($0, s) == 1' $input
    echo "extracting highest patch using sort"
    echo "extracting only first line using head"
    echo "extracting only last line using tail"
    awk -v s="$version" 'index($0, s) == 1' $input | sort -nr | head -n 1 | tail -c 3 
    echo "assinging above value to variable"
    echo "forming full version tmp_version"
    echo "adding +1 to above patch"
    tmp_version_1=`echo $version | sed 's/.*_//'`
    echo tmp_version_1 $tmp_version_1
    tmp_highest_patch=`awk -v s="$version" 'index($0, s) == 1' $input | sort -nr | head -n 1 | tail -c 3`
    echo tmp_highest_patch $tmp_highest_patch
    tmp_final_version=${myyear}.${week}.$tmp_highest_patch
    echo tmp_final_version $tmp_final_version
    newversion="$(printf "%06d" "$(expr "$(echo $tmp_final_version | sed 's/\.//g')" + 01)")"
    echo "${newversion:0:2}.${newversion:2:2}.${newversion:4:2}"
    echo "REL_VER=${newversion:0:2}.${newversion:2:2}.${newversion:4:2}" >> $GITHUB_ENV
    REL_VER_EXIST=true
    break
fi
done < "$input"

if [[ "$REL_VER_EXIST" == false  ]]; then
    echo "no 00 exist so patch set to 00"
    newversion=${myyear}.${week}.01
    echo "newversion" $newversion
    echo "REL_VER=${newversion}" >> $GITHUB_ENV
fi