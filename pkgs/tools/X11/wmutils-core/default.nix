{ stdenv, fetchurl, libxcb }:

stdenv.mkDerivation rec {
  name = "wmutils-core-${version}";
  version = "1.0";

  src = fetchurl {
    url = "https://github.com/wmutils/core/archive/v${version}.tar.gz";
    sha256 = "10vn56rbrjykcrjr06ki4qc12sri1ywrcvm89nmxlqhkxx4i239p";
  };

  buildInputs = [ libxcb ];

  installFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Set of window manipulation tools";
    homepage = https://github.com/wmutils/core;
    license = licenses.isc;
    platforms = platforms.unix;
  };
}
