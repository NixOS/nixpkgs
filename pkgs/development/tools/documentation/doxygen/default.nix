{stdenv, fetchurl, graphviz, perl, flex, bison, gnumake, libX11, libXext, qt}:

stdenv.mkDerivation rec {
  name = "doxygen-1.6.2";

  src = fetchurl {
    url = "ftp://ftp.stack.nl/pub/users/dimitri/${name}.src.tar.gz";
    sha256 = "0pqypiw8l8ajd3jy5nypb43zaf2vkyvkw4j0qr20xnjjhnliqbiv";
  };

  patches = [ ./tmake.patch ];

  buildInputs = [ graphviz perl flex bison libX11 libXext ]
    ++ (if (qt != null) then [ qt ] else []);

  prefixKey = "--prefix ";
  configureFlags = "--release"
		 + (if qt == null then "" else " --with-doxywizard")
		 ;

  preConfigure =
   (if (qt == null)
    then ""
    else ''
      echo "using QTDIR=${qt}..."
      export QTDIR=${qt}
    ''); 
      # export CPLUS_INCLUDE_PATH="${qt}/include:$CPLUS_INCLUDE_PATH"
      # export LIBRARY_PATH="${qt}/lib:$LIBRARY_PATH"

  meta = {
    description = "Doxygen, a source code documentation generator tool";

    longDescription = ''
      Doxygen is a documentation system for C++, C, Java, Objective-C,
      Python, IDL (CORBA and Microsoft flavors), Fortran, VHDL, PHP,
      C\#, and to some extent D.  It can generate an on-line
      documentation browser (in HTML) and/or an off-line reference
      manual (in LaTeX) from a set of documented source files.
    '';

    homepage = http://doxygen.org/;

    license = "GPLv2+";
  };
}
