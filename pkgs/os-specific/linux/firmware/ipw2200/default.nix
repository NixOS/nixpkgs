{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "ipw2200-fw-3.1";
  src = fetchurl {
    url = http://pkgs.fedoraproject.org/repo/pkgs/ipw2200-firmware/ipw2200-fw-3.1.tgz/eaba788643c7cc7483dd67ace70f6e99/ipw2200-fw-3.1.tgz;
    sha256 = "1gaqc8d827d6ji7zhhkpbr4fzznqpar68gzqbzak1h4cq48qr0f6";
  };
  
  buildPhase = "true";

  # Installation copies the firmware AND the license.  The license
  # says: "Your rights to redistribute the Software shall be
  # contingent upon your installation of this Agreement in its
  # entirety in the same directory as the Software."
  installPhase = "mkdir -p $out; cp * $out";
  
  meta = {
    # "... you may transfer a copy of the Software ... provided such
    # recipient agrees to be fully bound by the terms hereof."
    description = "Firmware for the Intel 2200BG wireless card (requires acceptance of license, see http://ipw2200.sourceforge.net/firmware.php?fid=8";
    homepage = http://ipw2200.sourceforge.net/firmware.php;
    license = http://ipw2200.sourceforge.net/firmware.php?fid=8;
    # See also http://ipw2100.sourceforge.net/firmware_faq.php
  };
}
