{ stdenv, fetchurl }:

let
  name = "astyle";
  version = "3.1";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}_${version}_linux.tar.gz";
    sha256 = "1ms54wcs7hg1bsywqwf2lhdfizgbk7qxc9ghasxk8i99jvwlrk6b";
  };

  sourceRoot = if stdenv.cc.isClang
    then "astyle/build/clang"
    else "astyle/build/gcc";

  # -s option is obsolete on Darwin and breaks build
  postPatch = if stdenv.isDarwin then ''
    substituteInPlace Makefile --replace "LDFLAGSr   = -s" "LDFLAGSr ="
  '' else null;

  installFlags = "INSTALL=install prefix=$$out";

  meta = {
    homepage = http://astyle.sourceforge.net/;
    description = "Source code indenter, formatter, and beautifier for C, C++, C# and Java";
    license = stdenv.lib.licenses.lgpl3;
    platforms = stdenv.lib.platforms.unix;
  };
}
