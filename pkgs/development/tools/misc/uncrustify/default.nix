{ lib, stdenv, fetchFromGitHub, cmake, python }:

stdenv.mkDerivation rec {
  name = "${product}-${version}";
  product = "uncrustify";
  version = "0.72.0";

  src = fetchFromGitHub {
    owner = product;
    repo = product;
    rev = name;
    sha256 = "sha256-ZVC5tsn2m1uB7EPNJFPLWLZpLSk4WrFOgJvy1KFYqBY=";
  };

  nativeBuildInputs = [ cmake python ];

  meta = with lib; {
    description = "Source code beautifier for C, C++, C#, ObjectiveC, D, Java, Pawn and VALA";
    homepage = "http://uncrustify.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
