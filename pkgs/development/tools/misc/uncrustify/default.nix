{ lib, stdenv, fetchFromGitHub, cmake, python2 }:

stdenv.mkDerivation rec {
  pname = "uncrustify";
  version = "0.72.0";

  src = fetchFromGitHub {
    owner = "uncrustify";
    repo = "uncrustify";
    rev = "uncrustify-${version}";
    sha256 = "sha256-ZVC5tsn2m1uB7EPNJFPLWLZpLSk4WrFOgJvy1KFYqBY=";
  };

  nativeBuildInputs = [ cmake python2 ];

  meta = with lib; {
    description = "Source code beautifier for C, C++, C#, ObjectiveC, D, Java, Pawn and VALA";
    homepage = "http://uncrustify.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
