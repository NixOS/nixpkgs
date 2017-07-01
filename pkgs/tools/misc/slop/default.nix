{ stdenv, fetchFromGitHub, cmake
, glm, mesa, gengetopt, libX11, libXext, libXrender, cppcheck}:

stdenv.mkDerivation rec {
  name = "slop-${version}";
  version = "6.3.41";

  src = fetchFromGitHub {
    owner = "naelstrof";
    repo = "slop";
    rev = "v${version}";
    sha256 = "051w2hcpz4qmvy7bmnzv7llxr2jbcpfxdadlzr2cidr323cann27";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ glm mesa gengetopt libX11 libXext libXrender ]
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
