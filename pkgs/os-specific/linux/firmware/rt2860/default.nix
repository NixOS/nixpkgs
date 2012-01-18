{stdenv, fetchsvn }:

# Upstream is http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git

stdenv.mkDerivation {
  name = "rt2860-fw-26";

  src = fetchsvn {
    url = svn://svn.debian.org/kernel/dists/trunk/firmware-nonfree/ralink;
    rev = 17279;
    sha256 = "06nc6w3xcrxzcai7gaf27k0v8k2xbq3imzpgc02rbxv5q5flxh65";
  };

  unpackPhase = "true";
  
  buildPhase = "true";

  # Installation copies the firmware AND the license.  The license
  # says: "Your rights to redistribute the Software shall be
  # contingent upon your installation of this Agreement in its
  # entirety in the same directory as the Software."
  installPhase = ''
    mkdir -p $out
    cp $src/rt2860.bin $out
    cp $src/LICENSE $out/rt2860.LICENSE
  '';
  
  meta = {
    description = "Firmware for the Ralink RT2860 wireless cards";
    homepage = http://www.ralinktech.com/;
    license = "non-free";
  };
}
