source $stdenv/setup

ensureDir $out

ln -s $kernel $out/kernel
ln -s $grub $out/grub

cat > $out/menu.lst << GRUBEND
title NixOS
        kernel $kernel selinux=0 apm=on acpi=on
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
    ln -sf $bootStage2 /init # !!! fix?
fi
EOF

chmod +x $out/bin/switch-to-configuration
