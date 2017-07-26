{ stdenv, fetchFromGitHub, cmake
, glew, glm, mesa, libX11, libXext, libXrender, cppcheck, icu}:

stdenv.mkDerivation rec {
  name = "slop-${version}";
  version = "6.3.47";

  src = fetchFromGitHub {
    owner = "naelstrof";
    repo = "slop";
    rev = "v${version}";
    sha256 = "05saxp5z2saq6b5hslxdc5kd7ln00svr5pazabcnchzydfhnkmsd";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ glew glm mesa libX11 libXext libXrender icu ]
                ++ stdenv.lib.optional doCheck cppcheck;

  doCheck = false;

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Queries a selection from the user and prints to stdout";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = with maintainers; [ primeos mbakke ];
  };
}
