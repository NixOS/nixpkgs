source $stdenv/setup

ensureDir $out

ln -s $kernel $out/kernel
ln -s $grub $out/grub

cat > $out/menu.lst << GRUBEND
kernel $kernel selinux=0 apm=on acpi=on init=$bootStage2
initrd $initrd
GRUBEND

ensureDir $out/bin

cat > $out/bin/switch-to-configuration <<EOF
#! $SHELL
set -e
export PATH=$coreutils/bin:$gnused/bin:$gnugrep/bin:$diffutils/bin
if test -n "$grubDevice"; then
    $grubMenuBuilder $out
    $grub/sbin/grub-install "$grubDevice" --no-floppy --recheck
fi
EOF

chmod +x $out/bin/switch-to-configuration
