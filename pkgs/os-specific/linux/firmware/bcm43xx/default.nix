{ stdenv, fetchurl }:

let
  src1 = fetchurl {
    url = "http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git;a=blob_plain;f=brcm/bcm43xx_hdr-0.fw;hb=15888a2eab052ac3d3f49334e4f6f05f347a516e";
    sha256 = "d02549964d21dd90fc35806483b9fc871d93d7d38ae1a70a9ce006103c2a3de3";
    name = "bcm43xx_hdr-0.fw";
  };

  src2 = fetchurl {
    url = "https://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git;a=blob_plain;f=brcm/bcm43xx-0.fw;hb=15888a2eab052ac3d3f49334e4f6f05f347a516e";
    sha256 = "f90f685903127e4db431fe1efccefebf77272712bd4bfe46d1d1d5825ee52797";
    name = "bcm43xx-0.fw";
  };
in
stdenv.mkDerivation {
  name = "bcm43xx-firmware-610.811";

  unpackPhase = "true";

  buildPhase = "true";

  installPhase = ''
    mkdir -p $out/brcm
    cp ${src1} $out/brcm/${src1.name}
    cp ${src2} $out/brcm/${src2.name}
  '';

  meta = {
    description = "Firmware for the Broadcom 43xx 802.11 wireless cards";
    homepage = http://linuxwireless.org/;
  };
}
