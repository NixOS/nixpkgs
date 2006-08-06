source $stdenv/setup
source $makeWrapper

makeWrapper "$grub/sbin/grub-install" "$out/sbin/grub-install" \
--suffix-each PATH ':' "$diffutils/bin $gnused/bin $gnugrep/bin $coreutils/bin"
