{ stdenv, fetchurl }:

let
  name = "astyle";
  version = "2.04";
in
stdenv.mkDerivation {
  name = "${name}-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/${name}/${name}_${version}_linux.tar.gz";
    sha256 = "0q3b2579ng01glfwan75zcyvkggixdz9c4i6cgid2664ad47zcvh";
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
