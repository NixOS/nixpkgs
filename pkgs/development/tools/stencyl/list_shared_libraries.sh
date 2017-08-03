#! /usr/bin/env bash

# $1 is the directory stencyl has been extracted to
cd "$1" 

# set up scope
shared_library_prefix='$out\/share'

# list the shared libraries
echo -e "\nSHARED LIBRARY FILES\n"
find -iname '*\.so*' -o -iname '*\.ndll*' | \
while read so; do
  file_info="$(file "$so")"
  if [[ "$file_info" =~ "64-bit" ]]; then
    echo "64-bit: $so"
  else 
    echo "32-bit: $so"
  fi
done | \
sort

# create a colon-delimited list of unique shared library dirs
echo -e "\nSHARED LIBRARY RPATH\n"
find -iname '*\.so*' -printf "%h\n" | \
grep -v "legacy" | \
sort | \
uniq | \
sed 's/^\./'"$shared_library_prefix"'/g;' | \
sed ':a;N;$!ba;s/\n/:/g'
