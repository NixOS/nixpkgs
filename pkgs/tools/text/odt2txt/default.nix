{ stdenv, fetchurl, zlib, libiconv }:

stdenv.mkDerivation rec {
  name = "odt2txt-0.4";

  src = fetchurl {
    url = "${meta.homepage}/${name}.tar.gz";
    sha256 = "1y36s7w2ng0r4nismxb3hb3zvsim8aimvvblz9hgnanw3kwbvx55";
  };

  configurePhase="export makeFlags=\"DESTDIR=$out\"";

  buildInputs = [ zlib libiconv ];

  NIX_LDFLAGS = stdenv.lib.optionalString stdenv.isDarwin "-liconv";

  meta = {
    description = "Simple .odt to .txt converter";
    homepage = http://stosberg.net/odt2txt;
    platforms = stdenv.lib.platforms.all;
    lincense = stdenv.lib.licenses.gpl2;
    maintainers = [ ];
  };
}
