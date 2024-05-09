{ stdenv, lib, fetchFromGitHub, coreutils, ubootOdroidXU3, runtimeShell }:

stdenv.mkDerivation {
  pname = "odroid-xu3-bootloader";
  version = "unstable-2015-12-04";

  src = fetchFromGitHub {
    owner = "hardkernel";
    repo = "u-boot";
    rev = "fe2f831fd44a4071f58a42f260164544697aa666";
    sha256 = "1h5yvawzla0vqhkk98gxcwc824bhc936bh6j77qkyspvqcw761fr";
  };

  buildCommand = ''
    install -Dm644 -t $out/lib/sd_fuse-xu3 $src/sd_fuse/hardkernel_1mb_uboot/{bl2,tzsw}.*
    install -Dm644 -t $out/lib/sd_fuse-xu3 $src/sd_fuse/hardkernel/bl1.*
    ln -sf ${ubootOdroidXU3}/u-boot-dtb.bin $out/lib/sd_fuse-xu3/u-boot-dtb.bin

    install -Dm755 $src/sd_fuse/hardkernel_1mb_uboot/sd_fusing.1M.sh $out/bin/sd_fuse-xu3
    sed -i \
      -e '1i#!${runtimeShell}' \
      -e '1iPATH=${lib.makeBinPath [ coreutils ]}:$PATH' \
      -e '/set -x/d' \
      -e 's,.\/sd_fusing\.sh,sd_fuse-xu3,g' \
      -e "s,\./,$out/lib/sd_fuse-xu3/,g" \
      $out/bin/sd_fuse-xu3
  '';

  meta = with lib; {
    platforms = platforms.linux;
    license = licenses.unfreeRedistributableFirmware;
    description = "Secure boot enabled boot loader for ODROID-XU{3,4}";
    maintainers = with maintainers; [ abbradar ];
  };
}
