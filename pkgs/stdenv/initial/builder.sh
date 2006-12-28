export PATH=/usr/bin:/bin

mkdir $out

sed -e "s^@initialPath@^/usr /^" -e "s^@preHook@^^" -e "s^@postHook@^^" -e "s^@shell@^/bin/sh^" < $stdenvScript > $out/setup
