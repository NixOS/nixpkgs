{ stdenv
, fetchurl
, skalibs
, skarnetConfCompile
}:

let

  version = "1.3.1.1";

in stdenv.mkDerivation rec {

  name = "execline-${version}";

  src = fetchurl {
    url = "http://skarnet.org/software/execline/${name}.tar.gz";
    sha256 = "1br3qzif166kbp4k813ljbyq058p7mfsp2lj88n8vi4dmj935nzg";
  };

  buildInputs = [ skalibs skarnetConfCompile ];

  sourceRoot = "admin/${name}";

  meta = {
    homepage = http://skarnet.org/software/execline/;
    description = "A small scripting language, to be used in place of a shell in non-interactive scripts";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.isc;
  };

}
