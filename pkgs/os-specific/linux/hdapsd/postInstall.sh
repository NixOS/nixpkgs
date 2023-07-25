mkdir -p $out/lib/udev/rules.d $out/lib/systemd/system
cp misc/hdapsd.rules $out/lib/udev/rules.d
SBIN_REWRITE="s|@sbindir@|$out/bin|g"
for i in misc/*.service.in
do sed $SBIN_REWRITE "$i" > "$out/lib/systemd/system/$(basename ${i%.in})"
done

