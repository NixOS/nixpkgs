#!/usr/bin/env nix-shell
<<<<<<< HEAD
#!nix-shell -i bash -p bash wget coreutils nix
=======
#!nix-shell -i bash -p bash wget coreutils gnutar nix
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
version=$1

if [[ -z $version ]]
then
    echo "Pass the version to get hashes for as an argument"
    exit 1
fi

allOutput=""

dlDest=$(mktemp)
<<<<<<< HEAD

trap 'rm $dlDest' EXIT
=======
exDest=$(mktemp -d)

trap 'rm $dlDest; rm -r $exDest' EXIT
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

for plat in osx linux; do
    for arch in x64 arm64; do

        URL="https://github.com/PowerShell/PowerShell/releases/download/v$version/powershell-$version-$plat-$arch.tar.gz"
        wget $URL -O $dlDest >&2

<<<<<<< HEAD
        hash=$(nix hash file $dlDest)
=======
        tar -xzf $dlDest -C $exDest >&2

        hash=$(nix hash path $exDest)
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

        allOutput+="
variant: $plat $arch
hash: $hash
"

<<<<<<< HEAD
=======
        rm -r $exDest
        mkdir $exDest

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    done
done

echo "$allOutput"
