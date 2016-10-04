{ stdenv, fetchurl, pkgconfig, globalplatform, pcsclite }:

stdenv.mkDerivation rec {
  name = "gpshell-${version}";
  version = "1.4.4";

  src = fetchurl {
    url = "mirror://sourceforge/globalplatform/gpshell-${version}.tar.gz";
    sha256 = "19a77zvyf2vazbv17185s4pynhylk2ky8vhl4i8pg9zww29sicqi";
  };

  buildInputs = [ pkgconfig globalplatform pcsclite ];

  meta = with stdenv.lib; {
    homepage = https://sourceforge.net/p/globalplatform/wiki/Home/;
    description = "Smartcard management application";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
