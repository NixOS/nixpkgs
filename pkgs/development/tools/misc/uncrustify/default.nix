{ lib, stdenv, fetchFromGitHub, cmake, python3 }:

stdenv.mkDerivation rec {
  pname = "uncrustify";
  version = "0.78.1";

  src = fetchFromGitHub {
    owner = "uncrustify";
    repo = "uncrustify";
    rev = "uncrustify-${version}";
    sha256 = "sha256-L+YEVZC7sIDYuCM3xpSfZLjA3B8XsW5hi+zV2NEgXTs=";
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
