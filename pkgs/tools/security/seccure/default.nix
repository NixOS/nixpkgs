{ stdenv, fetchurl, libgcrypt }:

stdenv.mkDerivation rec {
  name = "seccure-${version}";
  version = "0.5";
  
  src = fetchurl {
    url = "http://point-at-infinity.org/seccure/${name}.tar.gz";
    sha256 = "0nwnk3hfhgvf5xr0xipbh6smfnya22wphc5rj0vgi5d0zr5cwrk5";
  };

  buildInputs = [ libgcrypt ];
  
  preConfigure = ''
    sed -e s@/usr/@$out/@g -i Makefile
    sed -e 's@ln -f@ln -sf@g' -i Makefile
    mkdir -p $out/bin $out/share/man/man1
  '';

  meta = {
    homepage = http://point-at-infinity.org/seccure/;
    description = "Zero-configuration elliptic curve cryptography utility";
    platforms = stdenv.lib.platforms.unix;
  };
}
