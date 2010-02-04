#!/bin/bash

for i in `cat /var/db/pkg/fileutils-*/+CONTENTS | grep "bin/g"`
do
    name=`basename $i`
    echo "alias ${name:1}='g${name:1}'"
done

echo

for i in `cat /var/db/pkg/findutils-*/+CONTENTS | grep "bin/g"`
do
    name=`basename $i`
    echo "alias ${name:1}='g${name:1}'"
done

echo

for i in `cat /var/db/pkg/gdiff-*/+CONTENTS | grep "bin/g"`
do
    name=`basename $i`
    echo "alias ${name:1}='g${name:1}'"
done

echo

for i in `cat /var/db/pkg/ggrep-*/+CONTENTS | grep "bin/g"`
do
    name=`basename $i`
    echo "alias ${name:1}='g${name:1}'"
done

echo

for i in `cat /var/db/pkg/gmake-*/+CONTENTS | grep "bin/g"`
do
    name=`basename $i`
    echo "alias ${name:1}='g${name:1}'"
done

echo

for i in `cat /var/db/pkg/gsed-*/+CONTENTS | grep "bin/g"`
do
    name=`basename $i`
    echo "alias ${name:1}='g${name:1}'"
done

echo

for i in `cat /var/db/pkg/gtar-*/+CONTENTS | grep "bin/g"`
do
    name=`basename $i`
    echo "alias ${name:1}='g${name:1}'"
done

echo
 
