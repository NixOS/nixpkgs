{ stdenv, fetchurl, redland, pkgconfig, gmp }:

stdenv.mkDerivation rec {
  name = "redstore-0.4";

  src = fetchurl {
    url = "http://redstore.googlecode.com/files/${name}.tar.gz";
    sha256 = "1fs54v0d0kkqaz9ajacabb8wifrglvg6kkhd5b0mxmnng352wpp7";
  };

  buildInputs = [ gmp pkgconfig redland ];
      
  meta = {
    description = "An HTTP interface to Redland RDF store";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = with stdenv.lib.platforms;
      linux ++ freebsd ++ gnu;
  };
}
