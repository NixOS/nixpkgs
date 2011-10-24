{ stdenv, fetchsvn }:

stdenv.mkDerivation rec {
  name = "bcm43xx-firmware-610.811";

  # For convenience, get it from the Debian SVN repo.  Upstream seems to be
  # https://git.kernel.org/?p=linux/kernel/git/dwmw2/linux-firmware.git;a=tree;f=brcm
  src = fetchsvn {
    url = svn://svn.debian.org/kernel/dists/trunk/firmware-nonfree/brcm80211/brcm;
    rev = 17441;
    sha256 = "0dpc3kwgrslr3i00vx9pvvk2xvcwwf24yrbh6d5gxq9r1q65p8sz";
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
