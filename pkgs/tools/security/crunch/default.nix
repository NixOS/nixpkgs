{ stdenv, fetchurl, which }:

stdenv.mkDerivation  rec {
  name = "crunch-${version}";
  version = "3.6";

  src = fetchurl {
    url = "mirror://sourceforge/crunch-wordlist/${name}.tgz";
    sha256 = "0mgy6ghjvzr26yrhj1bn73qzw6v9qsniskc5wqq1kk0hfhy6r3va";
  };

  buildInputs = [ which ];

  configurePhase = "true";

  preBuild = ''
    sed 's/sudo //' -i Makefile
    sed 's/-g root -o root//' -i Makefile
  '';

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "Wordlist generator";
    homepage = https://sourceforge.net/projects/crunch-wordlist/;
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };
}
