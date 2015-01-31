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
