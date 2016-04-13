{ lib, stdenv, fetchurl, python2 }:

stdenv.mkDerivation rec {
  name = "waf-${version}";
  version = "1.8.19";

  src = fetchurl {
    url = "https://waf.io/waf-${version}.tar.bz2";
    sha256 = "e5df90556d1f70aca82bb5c5f46aa68d2377bae16b0db044eaa0559df8668c6f";
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

  meta = {
    description = "Meta build system";
    homepage    = "https://waf.io/";
    license     = lib.licenses.bsd3;
    platforms   = lib.platforms.all;
    maintainers = with lib.maintainers; [ ];
  };
}
