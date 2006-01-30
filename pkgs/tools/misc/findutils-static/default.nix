{stdenv, fetchurl, coreutils}:

stdenv.mkDerivation {
  name = "findutils-4.2.26";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/findutils-4.2.26.tar.gz;
    md5 = "9ac4e62937b1fdc4eb643d1d4bf117d3";
  };
  buildInputs = [coreutils];
  patches = [./findutils-path.patch];
  LDFLAGS="-static";
  configureFlags="--disable-nls --without-included-regex";
}
