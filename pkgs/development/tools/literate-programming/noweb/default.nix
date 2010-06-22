{stdenv, fetchurl, gawk}:

stdenv.mkDerivation {
  name = "noweb-2.11b";
  src = fetchurl {
    urls = [ "http://ftp.de.debian.org/debian/pool/main/n/noweb/noweb_2.11b.orig.tar.gz"
             "ftp://www.eecs.harvard.edu/pub/nr/noweb.tgz"
          ];
    sha256 = "10hdd6mrk26kyh4bnng4ah5h1pnanhsrhqa7qwqy6dyv3rng44y9";
  };
  preBuild = ''
    cd src
    makeFlags="BIN=$out/bin LIB=$out/lib MAN=$out/share/man TEXINPUTS=$out/share/texmf/tex/latex"
  '';
  preInstall=''mkdir -p $out/share/texmf/tex/latex'';
  postInstall= ''
    substituteInPlace $out/bin/cpif --replace "PATH=/bin:/usr/bin" ""
    for f in $out/bin/{noweb,nountangle,noroots,noroff,noindex} $out/lib/*; do
      substituteInPlace $f --replace "nawk" "${gawk}/bin/awk"
    done
  '';
  patches = [ ./no-FAQ.patch ];
}
