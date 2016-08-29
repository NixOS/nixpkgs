{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ifenslave-${version}";
  version = "1.1.0";

  src = fetchurl {
    url = "mirror://debian/pool/main/i/ifenslave-2.6/ifenslave-2.6_${version}.orig.tar.gz";
    sha256 = "0h9hrmy19zdksl7ys250r158b943ihbgkb95n8p4k8l0vqsby5vr";
  };

  buildPhase = ''
    gcc -o ifenslave ifenslave.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -a ifenslave $out/bin
  '';

  hardeningDisable = [ "format" ];

  meta = {
    description = "Utility for enslaving networking interfaces under a bond";
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
