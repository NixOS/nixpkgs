{stdenv, fetchurl, libtiff, libpng, lcms, libxmi, boost }:

stdenv.mkDerivation {
  name = "enblend-enfuse-3.2";

  src = fetchurl {
    url = mirror://sourceforge/enblend/enblend-enfuse-3.2.tar.gz;
    sha256 = "0ly6fdn5ym1v6m1f4gqc6s4zqgrfcys1ypfm82g5qbhh66x6gqw4";
  };

  buildInputs = [ libtiff libpng lcms libxmi boost ];

  meta = {
    homepage = http://enblend.sourceforge.net/;
    description = "Blends away the seams in a panoramic image mosaic using a multiresolution spline";
    license = "GPLv2";
  };
}
