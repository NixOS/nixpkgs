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

install_name_tool \
  -id $out/lib/system/libsystem_c.dylib \
  $out/lib/system/libsystem_c.dylib

install_name_tool \
  -id $out/lib/system/libsystem_kernel.dylib \
  $out/lib/system/libsystem_kernel.dylib

# TODO: this logic basically duplicates similar logic in the Libsystem expression. Deduplicate them!
libs=$(cat $reexportedLibrariesFile | grep -v '^#')

for i in $libs; do
  if [ "$i" != "/usr/lib/system/libsystem_kernel.dylib" ] && [ "$i" != "/usr/lib/system/libsystem_c.dylib" ]; then
    args="$args -reexport_library $i"
  fi
done

ld -macosx_version_min 10.7 \
   -arch x86_64 \
   -dylib \
   -o $out/lib/libSystem.B.dylib \
   -compatibility_version 1.0 \
   -current_version 1226.10.1 \
   -reexport_library $out/lib/system/libsystem_c.dylib \
   -reexport_library $out/lib/system/libsystem_kernel.dylib \
   $args

ln -s libSystem.B.dylib $out/lib/libSystem.dylib

for name in c dbm dl info m mx poll proc pthread rpcsvc util gcc_s.10.4 gcc_s.10.5; do
  ln -s libSystem.dylib $out/lib/lib$name.dylib
done

ln -s libresolv.9.dylib $out/lib/libresolv.dylib

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
