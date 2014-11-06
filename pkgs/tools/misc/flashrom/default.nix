{ stdenv, fetchurl, pkgconfig, libftdi, pciutils }:

let version = "0.9.7"; in
stdenv.mkDerivation rec {
  name = "flashrom-${version}";

  src = fetchurl {
    url = "http://download.flashrom.org/releases/${name}.tar.bz2";
    sha256 = "5a55212d00791981a9a1cb0cdca9d9e58bea6d399864251e7b410b4d3d6137e9";
  };

  buildInputs = [ pkgconfig libftdi pciutils ];

  makeFlags = ["PREFIX=$out"];

  meta = {
    homepage = "http://www.flashrom.org";
    description = "Utility for reading, writing, erasing and verifying flash ROM chips";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.funfunctor ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
