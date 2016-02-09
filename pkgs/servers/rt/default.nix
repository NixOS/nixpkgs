{ stdenv, fetchurl, perl }:

stdenv.mkDerivation rec {
  name = "rt-${version}";

  version = "4.2.12";

  src = fetchurl {
    url = "https://download.bestpractical.com/pub/rt/release/${name}.tar.gz";

    sha256 = "0r3jhgfwwhhk654zag42mrai85yrliw9sc0kgabwjvbh173204p2";
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
