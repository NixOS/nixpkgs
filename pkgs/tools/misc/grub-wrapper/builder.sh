. $stdenv/setup
. $makeWrapper

makeWrapper "$grub/sbin/grub-install" "$out/sbin/grub-install" \
--suffix-each PATH ':' "$diffutils/bin $gnused/bin $gnugrep/bin"

#echo "#! $SHELL -e" > $out/sbin/grub-install
#echo PATH=$diffutils/bin:$gnused/bin:$gnugrep/bin:$PATH >> $out/sbin/grub-install
#echo "exec \"$grub/sbin/grub-install\" \"\$@\"" >> $out/sbin/grub-install
#
#chmod +x $out/sbin/grub-install

