{ stdenv, fetchurl }:

let
  name = "astyle";
  version = "2.05.1";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}_${version}_linux.tar.gz";
    sha256 = "1b0f4wm1qmgcswmixv9mwbp86hbdqxk754hml8cjv5vajvqwdpzv";
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
