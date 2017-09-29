{ stdenv, fetchFromGitHub, cmake
, glew, glm, mesa, libX11, libXext, libXrender, cppcheck, icu}:

stdenv.mkDerivation rec {
  name = "slop-${version}";
  version = "7.3.49";

  src = fetchFromGitHub {
    owner = "naelstrof";
    repo = "slop";
    rev = "v${version}";
    sha256 = "0is3mh2d1jqgvv72v5x92w23yf26n8n384nbr1b6cn883aw8j7jz";
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
