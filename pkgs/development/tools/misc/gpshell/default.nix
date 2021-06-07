{ lib, stdenv, fetchurl, pkg-config, globalplatform, pcsclite, gppcscconnectionplugin
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "gpshell";
  version = "1.4.4";

  src = fetchurl {
    url = "mirror://sourceforge/globalplatform/gpshell-${version}.tar.gz";
    sha256 = "19a77zvyf2vazbv17185s4pynhylk2ky8vhl4i8pg9zww29sicqi";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [ globalplatform pcsclite ];

  postFixup = ''
    wrapProgram "$out/bin/gpshell" --prefix LD_LIBRARY_PATH : "${gppcscconnectionplugin}/lib"
  '';

  meta = with lib; {
    homepage = "https://sourceforge.net/p/globalplatform/wiki/Home/";
    description = "Smartcard management application";
    license = licenses.gpl3;
    platforms = platforms.all;
  };
}
