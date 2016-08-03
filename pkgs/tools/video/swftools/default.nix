{ stdenv, fetchurl, freetype, libjpeg, libungif, zlib }:

with stdenv.lib;
stdenv.mkDerivation rec {
  name = "swftools-${version}";
  version = "0.9.2";

  src = fetchurl {
    url = "http://www.swftools.org/${name}.tar.gz";
    sha256 = "1w81dyi81019a6jmnm5z7fzarswng27lg1d4k4d5llxzqszr2s5z";
  };

  patches = [ ./swftools.patch ];

  buildInputs = [ freetype libjpeg libungif zlib ];

  meta = {
    description = "Collection of SWF manipulation and creation utilities";
    homepage = http://www.swftools.org/about.html;
    license = licenses.gpl2;
    maintainers = [ maintainers.koral ];
    platforms = stdenv.lib.platforms.unix;
  };
}
