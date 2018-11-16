{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec{
  version = "3.03+dfsg2";
  name = "cowsay-${version}";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/c/cowsay/cowsay_${version}.orig.tar.gz";
    sha256 = "0ghqnkp8njc3wyqx4mlg0qv0v0pc996x2nbyhqhz66bbgmf9d29v";
  };

  buildInputs = [ perl ];

  installPhase = ''
    bash ./install.sh $out
  '';

  meta = with stdenv.lib; {
    description = "A program which generates ASCII pictures of a cow with a message";
    homepage = https://en.wikipedia.org/wiki/Cowsay;
    license = licenses.gpl1;
    platforms = platforms.all;
    maintainers = [ maintainers.rob ];
  };
}
