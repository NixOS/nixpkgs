{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "rt-${version}";

  version = "4.4.0";

  src = fetchurl {
    url = "https://download.bestpractical.com/pub/rt/release/${name}.tar.gz";

    sha256 = "1hgz50fxv9zdcngww083aqh8vzyk148lm7mcivxflpnsqfw3696x";
  };

  patches = [ ./override-generated.patch ];

  buildInputs = [ perl ];

  buildPhase = "true";

  installPhase = ''
    mkdir $out
    cp -a {bin,docs,etc,lib,sbin,share} $out
    find $out -name '*.in' -exec rm '{}' \;
  '';
}
