{ stdenv, fetchurl, boostHeaders }:

stdenv.mkDerivation rec {
  name = "mini-httpd-1.3";

  src = fetchurl {
    url = "mirror://savannah/mini-httpd/${name}.tar.gz";
    sha256 = "16n33hyp3fcjvd71yrny3ym3kqvxr1jy2hh9wgf6b7zjri3gfak3";
  };

  buildInputs = [ boostHeaders ];

  enableParallelBuilding = true;

  meta = {
    homepage = "http://mini-httpd.nongnu.org/";
    description = "a minimalistic high-performance web server";
    license = stdenv.lib.licenses.gpl3;
    platforms = stdenv.lib.platforms.unix;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
