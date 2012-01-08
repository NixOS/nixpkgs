{stdenv, fetchsvn }:

# Upstream is http://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git

stdenv.mkDerivation {
  name = "ralink-fw-r17279";

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
    ensureDir $out
    cp $src/*.bin $out
    cp $src/LICENSE $out/ralink.LICENSE
  '';
  
  meta = {
    description = "Firmware for the Ralink wireless cards";
    homepage = http://www.ralinktech.com/;
    license = "non-free";
  };
}
