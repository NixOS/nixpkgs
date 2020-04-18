{ stdenv, fetchurl, zlib, libiconv }:

stdenv.mkDerivation rec {
  pname = "odt2txt";
  version = "0.5";

  src = fetchurl {
    url = "${meta.homepage}/archive/v${version}.tar.gz";
    sha256 = "23a889109ca9087a719c638758f14cc3b867a5dcf30a6c90bf6a0985073556dd";
  };

  configurePhase="export makeFlags=\"DESTDIR=$out\"";

  buildInputs = [ zlib libiconv ];

  meta = {
    description = "Simple .odt to .txt converter";
    homepage = "https://github.com/dstosberg/odt2txt";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ ];
  };
}
