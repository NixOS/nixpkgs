{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ipw2100-fw-1.3";
  src = fetchurl {
    url = http://bughost.org/firmware/ipw2100-fw-1.3.tgz;
    sha256 = "18m7wgd062qwfdr6y0kjrvf1715wjcjn4yml2sk29ls8br2pq471";
  };

  unpackPhase = "tar xvzf $src";

  # Installation copies the firmware AND the license.  The license
  # says: "Your rights to redistribute the Software shall be
  # contingent upon your installation of this Agreement in its
  # entirety in the same directory as the Software."
  installPhase = "ensureDir $out; cp * $out";
  
  meta = {
    # "... you may transfer a copy of the Software ... provided such
    # recipient agrees to be fully bound by the terms hereof."
    description = "Firmware for the Intel 2100BG wireless card (requires acceptance of license, see http://ipw2100.sourceforge.net/firmware.php?fid=2)";
    homepage = http://ipw2100.sourceforge.net/firmware.php;
    license = http://ipw2100.sourceforge.net/firmware.php?fid=2;
  };
}
