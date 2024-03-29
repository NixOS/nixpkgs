set -euo pipefail

# Unpack the bootstrap tools tarball.
echo Unpacking the bootstrap tools...
$mkdir $out
$bzip2 -d < $tarball | (cd $out && $cpio -i)

export PATH=$out/bin

# Fix codesign wrapper paths
sed -i \
  -e "1c\
#!$out/bin/bash" \
  -e "s|[^( ]*\bsigtool\b|$out/bin/sigtool|g" \
  $out/bin/codesign

updateInstallName() {
  local path="$1"

  cp "$path" "$path.new"
  install_name_tool -id "$path" "$path.new"
  # workaround for https://github.com/NixOS/nixpkgs/issues/294518
  # libc++.1.0.dylib contains wrong LC_RPATH
  if [[ ${path} == *libc++.1.0.dylib ]]; then
    install_name_tool -add_rpath @loader_path/.. "${path}.new"
  fi
  codesign -f -i "$(basename "$path")" -s - "$path.new"
  mv -f "$path.new" "$path"
}

find $out

ln -s bash $out/bin/sh
ln -s bzip2 $out/bin/bunzip2

find $out/lib -type f -name '*.dylib' -print0 | while IFS= read -r -d $'\0' lib; do
  updateInstallName "$lib"
done

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
