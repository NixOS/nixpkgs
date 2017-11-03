{ stdenv, fetchurl, fetchpatch, libX11, libXext, xextproto, libICE, libSM, xproto, libpng12, zlib }:

stdenv.mkDerivation rec {
  name = "lincity-${version}";
  version = "1.13.1";

  src = fetchurl {
    url = "mirror://sourceforge/lincity/${name}.tar.gz";
    sha256 = "0p81wl7labyfb6rgp0hi42l2akn3n7r2bnxal1wyvjylzw8vsk3v";
  };

  buildInputs = [
    libICE libpng12 libSM libX11 libXext
    xextproto zlib xproto
  ];

  patches = [
    (fetchpatch {
      url = "https://sources.debian.net/data/main/l/lincity/1.13.1-13/debian/patches/extern-inline-functions-777982";
      sha256 = "06dp3zwk0z5wr5a3xaaj2my75vcjcy98vc22hsag7ggd9jwrkcp0";
    })
    (fetchpatch {
      url = "https://sources.debian.net/data/main/l/lincity/1.13.1-13/debian/patches/clang-ftbfs-757859";
      sha256 = "098rnywcsyc0m11x4a5m3dza8i0jmfh6pacfgma1vvxpsfkb6ngp";
    })
  ];

  meta = with stdenv.lib; {
    description = "City simulation game";
    license = licenses.gpl2Plus;
    homepage = https://sourceforge.net/projects/lincity;
  };
}
