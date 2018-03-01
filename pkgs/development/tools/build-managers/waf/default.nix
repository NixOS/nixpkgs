{ lib, stdenv, fetchurl, python2 }:

stdenv.mkDerivation rec {
  name = "waf-${version}";
  version = "2.0.4";

  src = fetchurl {
    url = "https://waf.io/waf-${version}.tar.bz2";
    sha256 = "0zmnwgccq5j7ipfi2j0k5s40q27krp1m6v2bd650axgzdbpa7ain";
  };

  buildInputs = [ python2 ];

  configurePhase = ''
    python waf-light configure
  '';
  buildPhase = ''
    python waf-light build
  '';
  installPhase = ''
    install waf $out
  '';

  meta = with stdenv.lib; {
    description = "Meta build system";
    homepage    = "https://waf.io/";
    license     = licenses.bsd3;
    platforms   = platforms.all;
    maintainers = with maintainers; [ vrthra ];
  };
}
