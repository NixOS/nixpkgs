{ lib, stdenv, fetchurl, boost, tcl }:

stdenv.mkDerivation rec {
  pname = "swig";
  version = "1.3.40";

  src = fetchurl {
    url = "mirror://sourceforge/swig/${pname}-${version}.tar.gz";
    sha256 = "02dc8g8wy75nd2is1974rl24c6mdl0ai1vszs1xpg9nd7dlv6i8r";
  };

  doCheck = !stdenv.isCygwin;
  # 'make check' uses boost and tcl
  buildInputs = lib.optionals doCheck [ boost tcl ];

  configureFlags = [ "--disable-ccache" ];


  meta = with lib; {
    description = "SWIG, an interface compiler that connects C/C++ code to higher-level languages";
    homepage = "https://swig.org/";
    # Different types of licenses available: http://www.swig.org/Release/LICENSE .
    license = licenses.gpl3Plus;
    platforms = with platforms; linux ++ darwin;
  };
}
