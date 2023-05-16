{ lib, stdenv, fetchFromGitHub, cmake, python3 }:

stdenv.mkDerivation rec {
  pname = "uncrustify";
<<<<<<< HEAD
  version = "0.77.1";
=======
  version = "0.76.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "uncrustify";
    repo = "uncrustify";
    rev = "uncrustify-${version}";
<<<<<<< HEAD
    sha256 = "sha256-9U6PTeU/LVFL9XzP9XSFjDx18CR3athThEz+h2+5qZ8=";
=======
    sha256 = "sha256-th3lp4WqqruHx2/ym3I041y2wLbYM1b+V6yXNOWuUvM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ cmake python3 ];

  meta = with lib; {
    description = "Source code beautifier for C, C++, C#, ObjectiveC, D, Java, Pawn and VALA";
    homepage = "https://uncrustify.sourceforge.net/";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.bjornfor ];
  };
}
