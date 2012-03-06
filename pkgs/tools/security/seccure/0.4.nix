{stdenv, fetchurl, libgcrypt}:

stdenv.mkDerivation rec {
  name = "seccure-0.4";
  
  src = fetchurl {
    url = "http://point-at-infinity.org/seccure/${name}.tar.gz";
    sha256 = "33d690a7034ee349bce4911a8b7c73e6e3cd13a140f429e9e628d5cd5a3bb955";
  };

  buildInputs = [libgcrypt];
  
  preConfigure = ''
    sed -e s@/usr/@$out/@g -i Makefile
    sed -e 's@ln -f@ln -sf@g' -i Makefile
    mkdir -p $out/bin $out/share/man/man1
  '';

  meta = {
    homepage = http://point-at-infinity.org/seccure/;
    description = "Zero-configuration elliptic curve cryptography utility";
  };
}
