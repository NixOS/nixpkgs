{ stdenv, fetchurl, perl, perlPackages, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "swaks";
  version = "20190914.0";

  src = fetchurl {
    url = "https://www.jetmore.org/john/code/swaks/files/${pname}-${version}.tar.gz";
    sha256 = "12awq5z4sdd54cxprj834zajxhkpy4jwhzf1fhigcx1zbhdaacsp";
  };

  buildInputs = [ perl makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    mv swaks $out/bin/

    wrapProgram $out/bin/swaks --set PERL5LIB \
      "${with perlPackages; makePerlPath [
        NetSSLeay AuthenSASL NetDNS IOSocketInet6
      ]}"
  '';

  meta = with stdenv.lib; {
    homepage = "http://www.jetmore.org/john/code/swaks/";
    description = "A featureful, flexible, scriptable, transaction-oriented SMTP test tool";
    license = licenses.gpl2;
    maintainers = with maintainers; [];
    platforms = platforms.all;
  };

}
