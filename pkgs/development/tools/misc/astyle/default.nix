{ stdenv, fetchurl }:

let
  name = "astyle";
  version = "2.02.1";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}_${version}_linux.tar.gz";
    sha256 = "0bece9a32887e51f42c57617cf7c4f9b63d0a386749fe3a094f5525b639ef953";
  };

  sourceRoot = "astyle/build/gcc";

  installFlags = "INSTALL=install prefix=$$out";

  meta = {
    homepage = "http://astyle.sourceforge.net/";
    description = "Source code indenter, formatter, and beautifier for C, C++, C# and Java";
    license = "LGPL";

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.simons ];
  };
}
