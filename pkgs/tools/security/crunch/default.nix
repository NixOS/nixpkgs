{ stdenv, fetchurl, which }:

stdenv.mkDerivation  rec {
  pname = "crunch";
  version = "3.6";

  src = fetchurl {
    url = "mirror://sourceforge/crunch-wordlist/${pname}-${version}.tgz";
    sha256 = "0mgy6ghjvzr26yrhj1bn73qzw6v9qsniskc5wqq1kk0hfhy6r3va";
  };

  buildInputs = [ which ];

  preBuild = ''
    substituteInPlace Makefile \
      --replace '-g root -o root' "" \
      --replace '-g wheel -o root' "" \
      --replace 'sudo ' ""
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with stdenv.lib; {
    description = "Wordlist generator";
    homepage = https://sourceforge.net/projects/crunch-wordlist/;
    platforms = platforms.unix;
    maintainers = with maintainers; [ lethalman lnl7 ];
  };
}
