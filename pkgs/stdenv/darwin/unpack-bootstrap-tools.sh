set -e

# Unpack the bootstrap tools tarball.
echo Unpacking the bootstrap tools...
$mkdir $out
$bzip2 -d < $tarball | (cd $out && $cpio -i)

# Set the ELF interpreter / RPATH in the bootstrap binaries.
echo Patching the tools...

export PATH=$out/bin

for i in $out/bin/*; do
  if ! test -L $i; then
    echo patching $i
    install_name_tool -add_rpath $out/lib $i || true
  fi
done

for i in $out/lib/*.dylib $out/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation; do
  if test ! -L "$i" -a "$i" != "$out/lib/libSystem*.dylib"; then
    echo "Patching $i"

    id=$(otool -D "$i" | tail -n 1)
    install_name_tool -id "$(dirname $i)/$(basename $id)" $i

    libs=$(otool -L "$i" | tail -n +2 | grep -v libSystem | cat)
    if [ -n "$libs" ]; then
      install_name_tool -add_rpath $out/lib $i
    fi
  fi
done

ln -s bash $out/bin/sh
ln -s bzip2 $out/bin/bunzip2

# Provide a gunzip script.
cat > $out/bin/gunzip <<EOF
#!$out/bin/sh
exec $out/bin/gzip -d "\$@"
EOF
chmod +x $out/bin/gunzip

# Provide fgrep/egrep.
echo "#! $out/bin/sh" > $out/bin/egrep
echo "exec $out/bin/grep -E \"\$@\"" >> $out/bin/egrep
echo "#! $out/bin/sh" > $out/bin/fgrep
echo "exec $out/bin/grep -F \"\$@\"" >> $out/bin/fgrep

cat >$out/bin/dsymutil << EOF
#!$out/bin/sh
EOF

chmod +x $out/bin/egrep $out/bin/fgrep $out/bin/dsymutil
