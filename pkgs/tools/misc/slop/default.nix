{ stdenv, fetchFromGitHub, cmake
, glm, mesa, libX11, libXext, libXrender, cppcheck, icu}:

stdenv.mkDerivation rec {
  name = "slop-${version}";
  version = "6.3.46";

  src = fetchFromGitHub {
    owner = "naelstrof";
    repo = "slop";
    rev = "v${version}";
    sha256 = "0k4i0s0rk82la9ac173whrjgrlw9977b2dgp34czi3knlkz9ynsg";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ glm mesa libX11 libXext libXrender icu ]
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
