{ lib, stdenv, fetchurl, python2 }:

stdenv.mkDerivation rec {
  name = "waf-${version}";
  version = "2.0.6";

  src = fetchurl {
    url = "https://waf.io/waf-${version}.tar.bz2";
    sha256 = "1wyl0jl10i0p2rj49sig5riyppgkqlkqmbvv35d5bqxri3y4r38q";
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
