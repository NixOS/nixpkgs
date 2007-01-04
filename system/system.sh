source $stdenv/setup

ensureDir $out

ln -s $kernel $out/kernel
ln -s $grub $out/grub
ln -s $bootStage2 $out/init
ln -s $initrd $out/initrd
ln -s $activateConfiguration $out/activate
ln -s $etc/etc $out/etc

echo "$kernelParams" > $out/kernel-params

cat > $out/menu.lst << GRUBEND
kernel $kernel init=$bootStage2 $kernelParams
initrd $initrd
GRUBEND

ensureDir $out/bin
substituteAll $switchToConfiguration $out/bin/switch-to-configuration
chmod +x $out/bin/switch-to-configuration
