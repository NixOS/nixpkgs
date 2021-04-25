{ lib, stdenv, grub2_xen_pvh }:

with lib;
let
  targets = {
    i686-linux.target = "i386";
    x86_64-linux.target = "i386"; # Xen PVH is only i386 on x86.
    aarch64-linux.target = "aarch64";
  };

in (

stdenv.mkDerivation rec {
  name = "pvhgrub-image";

  configs = ./configs;

  buildInputs = [ grub2_xen_pvh ];

  buildCommand = ''
    cp "${configs}"/* .
    tar -cf memdisk.tar grub.cfg
    # We include all modules except all_video.mod as otherwise grub will fail printing "no symbol table"
    # if we include it.
    grub-mkimage -O "${targets.${stdenv.hostPlatform.system}.target}-xen_pvh" -c grub-bootstrap.cfg \
      -m memdisk.tar -o "grub-${targets.${stdenv.hostPlatform.system}.target}-xen_pvh.bin" \
      $(ls "${grub2_xen_pvh}/lib/grub/${targets.${stdenv.hostPlatform.system}.target}-xen_pvh/" |grep 'mod''$'|grep -v '^all_video\.mod''$')
    mkdir -p "$out/lib/grub-xen_pvh"
    cp "grub-${targets.${stdenv.hostPlatform.system}.target}-xen_pvh.bin" $out/lib/grub-xen_pvh/
  '';

  meta = with lib; {
    description = "PVH Grub image for use for booting PVH Xen guests";

    longDescription =
      '' This package provides a PVH Grub image for booting HVM-based Para-Virtualized (PVH)
         Xen guests
      '';

    platforms = platforms.gnu ++ platforms.linux;
  };
})
