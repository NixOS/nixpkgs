source $stdenv/setup

ensureDir $out

ln -s $kernel $out/kernel
ln -s $grub $out/grub
ln -s $bootStage2 $out/init
ln -s $initrd $out/initrd
ln -s $activateConfiguration $out/activate
ln -s $etc/etc $out/etc
ln -s $systemPath $out/sw
ln -s $upstart $out/upstart

echo "$kernelParams" > $out/kernel-params
echo "$configurationName" > $out/configuration-name
echo "$upstartInterfaceVersion" > $out/upstart-interface-version

mkdir $out/fine-tune
ChildCount=0;
for i in $children; do 
	ChildCount=$(( ChildCount + 1 ));
	ln -s $i $out/fine-tune/child-$ChildCount;
done

cat > $out/menu.lst << GRUBEND
kernel $kernel init=$bootStage2 $kernelParams
initrd $initrd
GRUBEND

ensureDir $out/bin
substituteAll $switchToConfiguration $out/bin/switch-to-configuration
chmod +x $out/bin/switch-to-configuration
