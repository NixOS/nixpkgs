{ stdenv, fetchFromGitHub, cmake, python }:

stdenv.mkDerivation rec {
  name = "${product}-${version}";
  product = "uncrustify";
  version = "0.70.1";

  src = fetchFromGitHub {
    owner = product;
    repo = product;
    rev = name;
    sha256 = "0zr3vxhd947zdvwccw3cj0vsriaawcpfjq3x94v9887hsi8fk87b";
  };

  nativeBuildInputs = [ cmake python ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Source code beautifier for C, C++, C#, ObjectiveC, D, Java, Pawn and VALA";
    homepage = http://uncrustify.sourceforge.net/;
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
