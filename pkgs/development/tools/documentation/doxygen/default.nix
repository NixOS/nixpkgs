{stdenv, fetchurl, graphviz, perl, flex, bison, gnumake, libX11, libXext, qt}:

stdenv.mkDerivation rec {
  name = "doxygen-1.5.7.1";
  src = fetchurl {
    url = "ftp://ftp.stack.nl/pub/users/dimitri/${name}.src.tar.gz";
    sha256 = "0abds9d2ff4476105myl4933q6l4vqyyyajx6qial88iffbczsbw";
  };
  buildInputs = [graphviz perl flex bison libX11 libXext qt];
  prefixKey = "--prefix ";
  configureFlags = "--release"
		 + " --make ${gnumake}/bin/make"
		 + (if qt == null then "" else " --with-doxywizard")
		 ;
}
