{ lib, stdenv, fetchurl, perl, perlPackages, makeWrapper }:

stdenv.mkDerivation rec {
  pname = "swaks";
  version = "20201014.0";

  src = fetchurl {
    url = "https://www.jetmore.org/john/code/swaks/files/${pname}-${version}.tar.gz";
    sha256 = "0c2sx4nrh4whsqzj6m5ay8d7yqan3aqgg436p8jb25bs91ykn2pv";
  };

  nativeBuildInputs = [ makeWrapper ];
  buildInputs = [ perl ];

  installPhase = ''
    mkdir -p $out/bin
    mv swaks $out/bin/

    wrapProgram $out/bin/swaks --set PERL5LIB \
      "${with perlPackages; makePerlPath [
        NetSSLeay AuthenSASL NetDNS IOSocketINET6
      ]}"
  '';

  meta = with lib; {
    homepage = "http://www.jetmore.org/john/code/swaks/";
    description = "A featureful, flexible, scriptable, transaction-oriented SMTP test tool";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [];
    platforms = platforms.all;
  };

}
