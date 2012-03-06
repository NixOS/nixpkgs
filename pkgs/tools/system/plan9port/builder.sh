source $stdenv/setup

tar xvfz $src

cd plan9

export PLAN9=`pwd`
export X11=/tmp

# Patch for the installation
sed -i -e 's@`which echo`@echo@' lib/moveplan9.sh

OLDPATH=$PATH
PATH=`pwd`/bin:$PATH

gcc lib/linux-isnptl.c -lpthread
set +e 
if ./a.out > /dev/null
then
  echo "SYSVERSION=2.6.x" >config
else
  echo "SYSVERSION=2.4.x" >config
fi
rm -f ./a.out
set -e

pushd src

# Build mk
../dist/buildmk 2>&1 | sed 's/^[+] //'

# Build everything

mk clean
mk libs-nuke
mk all || exit 1
mk install || exit 1

popd

# Installation
export PLAN9=$out
mkdir -p $PLAN9
GLOBIGNORE='src:.*'
cp -R * $PLAN9
GLOBIGNORE=

cd $PLAN9
sh lib/moveplan9.sh `pwd`
