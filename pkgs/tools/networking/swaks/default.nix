{ stdenv, fetchurl, perl, perlPackages, makeWrapper }:

stdenv.mkDerivation rec {
  name = "swaks-${version}";
  version = "20130209.0";

  src = fetchurl {
    url = "http://www.jetmore.org/john/code/swaks/files/${name}.tar.gz";
    sha256 = "0z0zsjminrdjpn6a8prjdwilnr27piibh78gc5ppg0nadljnf28b";
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
    homepage = "http://www.jetmore.org/john/code/swaks/";
    description = ''
      A featureful, flexible, scriptable, transaction-oriented SMTP test tool
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ rickynils ];
    platforms = platforms.all;
  };

}
