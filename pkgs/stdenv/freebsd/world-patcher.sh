#!/bin/sh

export PATH=/bin:/sbin:/usr/bin:/usr/sbin

mkdir -p $out $outbin
cp -r $world/* $out
chmod -R +w $out

# UGHHHHHHHHHHH
mv $out/bin $outbin/bin
mv $out/sbin $outbin/sbin
mkdir $outbin/usr
mv $out/usr/bin $outbin/usr/bin
mv $out/usr/sbin $outbin/usr/sbin

mkdir -p $corebin/bin $lib/lib $cc/bin $sh/bin $zip/bin
ln -sf $outbin/usr/bin/* $corebin/bin
ln -sf $outbin/usr/sbin/* $corebin/bin
ln -sf $outbin/bin/* $corebin/bin
ln -sf $outbin/sbin/* $corebin/bin
ln -sf $out/lib/* $lib/lib
ln -sf $out/usr/lib/* $lib/lib
ln -sf $out/libexec $lib/libexec

find $outbin/bin $outbin/sbin $outbin/usr/bin $outbin/usr/sbin -type f | while read FILE; do
    INTERPRETER="$($patchelf --print-interpreter $FILE 2>/dev/null)"
    if [ -n "$INTERPRETER" ]; then
        INTERPRETER="$(echo "$INTERPRETER" | sed -e "s,^/libexec/,$out/libexec/,")"
        $patchelf --set-interpreter $INTERPRETER --set-rpath $out/lib $FILE
    fi
    SHEBANG="$(head -n1 $FILE)"
    if [ "$(echo "$SHEBANG" | cut -c -2)" = '#!' ]; then
        TEMP=$(mktemp)
        SHEBANG='#!'"$(echo "$SHEBANG" | cut -c 3- | sed -e "s,^/bin/,$outbin/bin/," -e "s,^/usr/bin/,$outbin/usr/bin/," -e "s,^/sbin/,$outbin/sbin/," -e "s,^/usr/sbin/,$outbin/usr/sbin/,")"
        echo "$SHEBANG" >$TEMP
        tail +2 $FILE >>$TEMP
        mv $TEMP $FILE
        chmod +x $FILE
    fi
done

for f in cc clang clang++ ld ld.lld cpp ar; do
    ln -s $corebin/bin/$f $cc/bin
done

# sigh
mkdir -p $outbin/usr/lib $cc/lib
ln -s $lib/lib/clang $outbin/usr/lib
ln -s $lib/lib/clang $cc/lib

for f in sh; do
    ln -s $corebin/bin/$f $sh/bin
done
for f in gzip bzip2 xz gunzip unxz bzip2recover xzcat xzdec xzdiff xzegrep xzfgrep xzgrep xzless; do
    ln -s $corebin/bin/$f $zip/bin
done
