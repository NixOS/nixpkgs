{ stdenv, fetchurl, libtool, autoconf, automake, gnum4, linkStatic ? false }:

let version = "1.0.6"; in

stdenv.mkDerivation {
  name = "bzip2-${version}";

  builder = ./builder.sh;

  src = fetchurl {
    url = "http://www.bzip.org/${version}/bzip2-${version}.tar.gz";
    sha256 = "1kfrc7f0ja9fdn6j1y6yir6li818npy6217hvr3wzmnmzhs8z152";
  };

  crossAttrs = {
    builder = (stdenv.mkDerivation { }).builder;  # reset to standard builder
    args = (stdenv.mkDerivation { }).args;  # reset to standard args
    buildInputs = [ libtool autoconf automake gnum4 ];
    patches = [ ./bzip2-1.0.6-autoconfiscated.patch ];
    postPatch = ''
      sed -i -e '/<sys\\stat\.h>/s|\\|/|' bzip2.c
    '';
    preConfigure = "sh ./autogen.sh";
  };

  sharedLibrary =
    !stdenv.isDarwin && !(stdenv ? isStatic) && stdenv.system != "i686-cygwin" && !linkStatic;

  patchPhase = stdenv.lib.optionalString stdenv.isDarwin "substituteInPlace Makefile --replace 'CC=gcc' 'CC=clang'";

  preConfigure = "substituteInPlace Makefile --replace '$(PREFIX)/man' '$(PREFIX)/share/man'";

  makeFlags = if linkStatic then "LDFLAGS=-static" else "";

  inherit linkStatic;

  meta = {
    homepage = "http://www.bzip.org";
    description = "high-quality data compression program";

    platforms = stdenv.lib.platforms.all;
    maintainers = [];
  };
}
