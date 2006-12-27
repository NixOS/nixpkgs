set -e

PATH=$staticTools/bin

mkdir $out

sed -e "s^@initialPath@^$staticTools^" -e "s^@preHook@^^" -e "s^@postHook@^^" < $stdenvScript > $out/setup
