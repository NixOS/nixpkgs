#!/bin/sh

export PATH=/bin:/sbin:/usr/bin:/usr/sbin

mkdir -p $corebin/bin $etc/etc $lib/lib $lib/libexec $cc/bin $sh/bin $zip/bin

tar -C $world/bin -c . | tar -C $corebin/bin -x
tar -C $world/sbin -c . | tar -C $corebin/bin -x
tar -C $world/usr/bin -c . | tar -C $corebin/bin -x
tar -C $world/usr/sbin -c . | tar -C $corebin/bin -x
tar -C $world/etc -c . | tar -C $etc/etc -x
tar -C $world/lib -c . | tar -C $lib/lib -x
tar -C $world/usr/lib -c . | tar -C $lib/lib -x
tar -C $world/libexec -c . | tar -C $lib/libexec -x

chmod -R +w $corebin
find $corebin -type f | while read FILE; do
    INTERPRETER="$($patchelf --print-interpreter $FILE 2>/dev/null)"
    if [ -n "$INTERPRETER" ]; then
        INTERPRETER="$(echo "$INTERPRETER" | sed -e "s,^/libexec/,$lib/libexec/,")"
        $patchelf --set-interpreter $INTERPRETER --set-rpath $lib/lib $FILE
    fi
    SHEBANG="$(head -n1 $FILE)"
    if [ "$(echo "$SHEBANG" | cut -c -2)" = '#!' ]; then
        TEMP=$(mktemp)
        SHEBANG='#!'"$(echo "$SHEBANG" | cut -c 3- | sed -e "s,^/bin/,$corebin/bin/," -e "s,^/usr/bin/,$corebin/bin/," -e "s,^/sbin/,$corebin/bin/," -e "s,^/usr/sbin/,$corebin/bin/,")"
        echo "$SHEBANG" >$TEMP
        tail +2 $FILE >>$TEMP
        mv $TEMP $FILE
        chmod +x $FILE
    fi
done

for f in $(find $lib/lib -lname '../../lib/*'); do
    LINK="$(readlink $f)"
    RELINK="${LINK#../../lib/}"
    rm $f
    ln -s $RELINK $f
done

for f in cc clang clang++ ld ld.lld cpp ar; do
    mv $corebin/bin/$f $cc/bin
done
for f in sh; do
    mv $corebin/bin/$f $sh/bin
done
for f in gzip bzip2 xz gunzip unxz bzip2recover xzcat xzdec xzdiff xzegrep xzfgrep xzgrep xzless; do
    mv $corebin/bin/$f $zip/bin
done
