{ stdenv, fetchurl, perl, perlPackages, makeWrapper }:

stdenv.mkDerivation rec {
  name = "swaks-${version}";
  version = "20181104.0";

  src = fetchurl {
    url = "https://www.jetmore.org/john/code/swaks/files/${name}.tar.gz";
    sha256 = "0n1yd27xcyb1ylp5gln3yv5gzi9r377hjy1j32367kgb3247ygq2";
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
    homepage = http://www.jetmore.org/john/code/swaks/;
    description = ''
      A featureful, flexible, scriptable, transaction-oriented SMTP test tool
    '';
    license = licenses.gpl2;
    maintainers = with maintainers; [ rickynils ndowens ];
    platforms = platforms.all;
  };

}
