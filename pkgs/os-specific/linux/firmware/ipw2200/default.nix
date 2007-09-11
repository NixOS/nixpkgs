{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ipw2200-fw-3.0";
  src = fetchurl {
    url = http://bughost.org/firmware/ipw2200-fw-3.0.tgz;
    sha256 = "1skmxmngrgz1402yq4vbfwmghh04mn1031jrn2cli0scdxz00zm7";
  };
  
  buildPhase = "true";

  # Installation copies the firmware AND the license.  The license
  # says: "Your rights to redistribute the Software shall be
  # contingent upon your installation of this Agreement in its
  # entirety in the same directory as the Software."
  installPhase = "ensureDir $out; cp * $out";
  
  meta = {
    # "... you may transfer a copy of the Software ... provided such
    # recipient agrees to be fully bound by the terms hereof."
    description = "Firmware for the Intel 2200BG wireless card (requires acceptance of license, see http://ipw2200.sourceforge.net/firmware.php?fid=7";
    homepage = http://ipw2200.sourceforge.net/firmware.php;
    license = http://ipw2200.sourceforge.net/firmware.php?fid=7;
    # See also http://ipw2100.sourceforge.net/firmware_faq.php
  };
}
