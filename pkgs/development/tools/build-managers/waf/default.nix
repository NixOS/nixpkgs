{ lib, stdenv, fetchurl, python2 }:

stdenv.mkDerivation rec {
  name = "waf-${version}";
  version = "1.9.0";

  src = fetchurl {
    url = "https://waf.io/waf-${version}.tar.bz2";
    sha256 = "1sjpqzm2fzm8pxi3fwfinpsbw4z9040qkrzbg3lxik7ppsbjhn58";
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
