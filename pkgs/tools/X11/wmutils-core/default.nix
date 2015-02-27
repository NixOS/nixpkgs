{ lib, stdenv, fetchurl, libxcb }:

stdenv.mkDerivation rec {
  name = "wmutils-core-${version}";
  version = "1.0";

  src = fetchurl {
    url = "https://github.com/wmutils/core/archive/v1.0.tar.gz";
    sha256 = "10vn56rbrjykcrjr06ki4qc12sri1ywrcvm89nmxlqhkxx4i239p";
  };

  buildInputs = [ libxcb ];

  buildPhase = ''
    make PREFIX=$out
  '';

  installPhase = ''
    make PREFIX=$out install
  '';

  meta = with lib; {
    description = "Set of window manipulation tools";
    homepage = https://github.com/wmutils/core;
	license = stdenv.lib.licenses.isc;
	platforms = platforms.unix;
  };
}
