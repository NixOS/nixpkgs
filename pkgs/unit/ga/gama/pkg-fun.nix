{ stdenv, fetchurl, lib, expat, octave, libxml2, texinfo, zip }:
stdenv.mkDerivation rec {
  pname = "gama";
  version = "2.23";

  src = fetchurl {
    url = "mirror://gnu/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-OKVAgmHdhQoS3kCwclE9ljON3H2NVCCvpR2hgwfqnA0=";
  };

  buildInputs = [ expat ];

  nativeBuildInputs = [ texinfo zip ];

  nativeCheckInputs = [ octave libxml2 ];
  doCheck = true;

  meta = with lib ; {
    description = "Tools for adjustment of geodetic networks";
    homepage = "https://www.gnu.org/software/gama/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
  };
}
