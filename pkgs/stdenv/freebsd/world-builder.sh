#!/bin/sh

export PATH=/bin:/sbin:/usr/bin:/usr/sbin

mkdir -p obj
export MAKEOBJDIRPREFIX="$(realpath obj)"
tar -zxvf $src
cd $dname

make world DESTDIR=$out -j $NIX_BUILD_CORES -DNO_ROOT

mkdir -p $corebin/bin $lib/lib $cc $sh $zip
ln -s $out/bin/* $corebin/bin
ln -s $out/sbin/* $corebin/bin
ln -s $out/usr/bin/* $corebin/bin
ln -s $out/usr/sbin/* $corebin/bin
ln -s $out/lib/* $lib/lib
ln -s $out/usr/lib/* $lib/lib
ln -s $out/libexec $lib/libexec

find $out/bin $out/sbin $out/usr/bin $out/usr/sbin -type f | while read FILE; do
    INTERPRETER="$($patchelf --print-interpreter $FILE 2>/dev/null)"
    if [ -n "$INTERPRETER" ]; then
        INTERPRETER="$(echo "$INTERPRETER" | sed -e "s,^/libexec/,$out/libexec/,")"
        $patchelf --set-interpreter $INTERPRETER --set-rpath $out/lib $FILE
    fi
    SHEBANG="$(head -n1 $FILE)"
    if [ "$(echo "$SHEBANG" | cut -c -2)" = '#!' ]; then
        TEMP=$(mktemp)
        SHEBANG='#!'"$(echo "$SHEBANG" | cut -c 3- | sed -e "s,^/bin/,$out/bin/," -e "s,^/usr/bin/,$out/usr/bin/," -e "s,^/sbin/,$out/sbin/," -e "s,^/usr/sbin/,$out/usr/sbin/,")"
        echo "$SHEBANG" >$TEMP
        tail +2 $FILE >>$TEMP
        mv $TEMP $FILE
        chmod +x $FILE
    fi
done

for f in cc clang clang++ ld ld.lld cpp ar; do
    ln -s $corebin/bin/$f $cc/bin
done
for f in sh; do
    ln -s $corebin/bin/$f $sh/bin
done
for f in gzip bzip2 xz gunzip unxz bzip2recover xzcat xzdec xzdiff xzegrep xzfgrep xzgrep xzless; do
    ln -s $corebin/bin/$f $zip/bin
done
