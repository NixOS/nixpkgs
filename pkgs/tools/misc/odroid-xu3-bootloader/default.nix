{ stdenv, lib, fetchFromGitHub, coreutils, ubootOdroidXU3 }:

stdenv.mkDerivation {
  name = "odroid-xu3-bootloader-2015-12-04";

  src = fetchFromGitHub {
    owner = "hardkernel";
    repo = "u-boot";
    rev = "bbdea1841c4fbf767dcaf9d7ae8d3a46af235c4d";
    sha256 = "03rvyfj147xh83w8hlvbxix131l3nnvk8n517fdhv9nil1l8dd71";
  };

  buildCommand = ''
    install -Dm644 -t $out/lib/sd_fuse-xu3 $src/sd_fuse/hardkernel/*.hardkernel
    ln -sf ${ubootOdroidXU3}/u-boot.bin $out/lib/sd_fuse-xu3/u-boot.bin.hardkernel

    install -Dm755 $src/sd_fuse/hardkernel/sd_fusing.sh $out/bin/sd_fuse-xu3
    sed -i \
      -e '1i#!${stdenv.shell}' \
      -e '1iPATH=${lib.makeBinPath [ coreutils ]}:$PATH' \
      -e "s,if=\./,if=$out/lib/sd_fuse-xu3/,g" \
      $out/bin/sd_fuse-xu3
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    license = licenses.unfreeRedistributableFirmware;
    description = "Secure boot enabled boot loader for ODROID-XU{3,4}";
    maintainers = with maintainers; [ abbradar ];
  };
}
