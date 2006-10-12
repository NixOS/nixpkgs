{stdenv, fetchurl, zlib, libX11, libpng}:

stdenv.mkDerivation {
  name = "ploticus-2.33";

  builder = ./builder.sh;
  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/pl233src.tar.gz;
    md5 = "1e242200e7e52f7a24041c95f58f2fc1";
  };

  buildInputs = [zlib libX11 libpng];

  patches = [./ploticus-install.patch];
}
