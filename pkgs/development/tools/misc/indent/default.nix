{ stdenv, fetchurl, texinfo }:

stdenv.mkDerivation rec {
  name = "indent-2.2.12";

  src = fetchurl {
    url = "mirror://gnu/indent/${name}.tar.gz";
    sha256 = "12xvcd16cwilzglv9h7sgh4h1qqjd1h8s48ji2dla58m4706hzg7";
  };

  patches = [ ./darwin.patch ];

  buildInputs = [ texinfo ];

  NIX_CFLAGS_COMPILE = stdenv.lib.optionalString stdenv.cc.isClang
    "-Wno-implicit-function-declaration";

  hardeningDisable = [ "format" ];

  meta = {
    homepage = "https://www.gnu.org/software/indent/";
    description = "A source code reformatter";
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.mmahut ];
    platforms = stdenv.lib.platforms.unix;
  };
}
