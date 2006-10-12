{stdenv, fetchurl, coreutils}:

stdenv.mkDerivation {
  name = "findutils-4.2.27";
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/findutils-4.2.27.tar.gz;
    md5 = "f1e0ddf09f28f8102ff3b90f3b5bc920";
  };
  buildInputs = [coreutils];
  patches = [./findutils-path.patch];
}
