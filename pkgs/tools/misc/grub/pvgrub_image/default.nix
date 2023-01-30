{ lib, stdenv, grub2_xen }:

let
  efiSystemsBuild = {
    i686-linux.target = "i386";
    x86_64-linux.target = "x86_64";
    aarch64-linux.target = "aarch64";
  };

in (

stdenv.mkDerivation rec {
  name = "pvgrub-image";

  configs = ./configs;

  buildInputs = [ grub2_xen ];

  buildCommand = ''
    cp "${configs}"/* .
    tar -cf memdisk.tar grub.cfg
    # We include all modules except all_video.mod as otherwise grub will fail printing "no symbol table"
    # if we include it.
    grub-mkimage -O "${efiSystemsBuild.${stdenv.hostPlatform.system}.target}-xen" -c grub-bootstrap.cfg \
      -m memdisk.tar -o "grub-${efiSystemsBuild.${stdenv.hostPlatform.system}.target}-xen.bin" \
      $(ls "${grub2_xen}/lib/grub/${efiSystemsBuild.${stdenv.hostPlatform.system}.target}-xen/" |grep 'mod''$'|grep -v '^all_video\.mod''$')
    mkdir -p "$out/lib/grub-xen"
    cp "grub-${efiSystemsBuild.${stdenv.hostPlatform.system}.target}-xen.bin" $out/lib/grub-xen/
  '';

  meta = with lib; {
    description = "PvGrub image for use for booting PV Xen guests";

    longDescription =
      '' This package provides a PvGrub image for booting Para-Virtualized (PV)
         Xen guests
      '';

    platforms = platforms.gnu ++ platforms.linux;
  };
})
