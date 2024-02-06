set -euo pipefail

export PATH=$tools/bin

cp -R $tools $out
chmod -R u+w $out

updateInstallName() {
  local path="$1"

  cp "$path" "$path.new"
  install_name_tool -id "$path" "$path.new"
  codesign -f -i "$(basename "$path")" -s - "$path.new"
  mv -f "$path.new" "$path"
}

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
