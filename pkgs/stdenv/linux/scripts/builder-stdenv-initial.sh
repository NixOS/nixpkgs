set -e

PATH=$staticTools/bin

mkdir $out

sed -e "s^@initialPath@^$staticTools^" -e "s^@preHook@^^" -e "s^@postHook@^^" -e "s^@shell@^$SHELL^" < $stdenvScript > $out/setup
