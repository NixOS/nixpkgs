{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "bcm43xx-firmware-610.811";

  src = fetchurl {
    url = "https://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=snapshot;h=e62f89cefb4660a16b192c57b446cac975836d05;sf=tgz";
    sha256 = "a4409c3ed21b5650da9277873e4b05228937ed65526bffd9c93d09cbdf7935b2";
    name = "brcm-e62f89cefb4660a16b192c57b446cac975836d05.tar.gz";
  };

  buildPhase = "true";

  installPhase = ''
    mkdir -p $out/brcm
    for i in *.fw*; do
      cp $i $out/brcm/$(echo $i | sed 's/\(.*\.fw\).*/\1/')
    done
  '';

  meta = {
    description = "Firmware for the Broadcom 43xx 802.11 wireless cards";
    homepage = http://linuxwireless.org/;
  };
}
