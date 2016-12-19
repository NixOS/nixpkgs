{ stdenv, fetchurl, pkgconfig, libftdi, pciutils }:

let version = "0.9.9"; in
stdenv.mkDerivation rec {
  name = "flashrom-${version}";

  src = fetchurl {
    url = "http://download.flashrom.org/releases/${name}.tar.bz2";
    sha256 = "0i9wg1lyfg99bld7d00zqjm9f0lk6m0q3h3n9c195c9yysq5ccfb";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libftdi pciutils ];

  preConfigure = "export PREFIX=$out";

  meta = {
    homepage = "http://www.flashrom.org";
    description = "Utility for reading, writing, erasing and verifying flash ROM chips";
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.funfunctor ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
