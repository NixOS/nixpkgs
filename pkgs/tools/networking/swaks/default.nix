{ stdenv, fetchurl, perl, perlPackages, makeWrapper }:

stdenv.mkDerivation rec {
  name = "swaks-${version}";
  version = "20170101.0";

  src = fetchurl {
    url = "http://www.jetmore.org/john/code/swaks/files/${name}.tar.gz";
    sha256 = "0pli4mlhasnqqxmmxalwyg3x7n2vhcbgsnp2xgddamjavv82vrl4";
  };

  buildInputs = [ perl makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    mv swaks $out/bin/

    wrapProgram $out/bin/swaks --set PERL5LIB \
      "${with perlPackages; stdenv.lib.makePerlPath [
        NetSSLeay AuthenSASL NetDNS IOSocketInet6
      ]}"
  '';

  meta = with stdenv.lib; {
    homepage = http://www.jetmore.org/john/code/swaks/;
    description = ''
      A featureful, flexible, scriptable, transaction-oriented SMTP test tool
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ rickynils ndowens ];
    platforms = platforms.all;
  };

}
