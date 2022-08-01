{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, glew
, glm
, libGLU
, libGL
, libX11
, libXext
, libXrender
, icu
, libSM
}:

stdenv.mkDerivation rec {
  pname = "slop";
  version = "7.6";

  src = fetchFromGitHub {
    owner = "naelstrof";
    repo = "slop";
    rev = "v${version}";
    sha256 = "sha256-LdBQxw8K8WWSfm4E2QpK4GYTuYvI+FX5gLOouVFSU/U=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    glew
    glm
    libGLU
    libGL
    libX11
    libXext
    libXrender
    icu
    libSM
  ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Queries a selection from the user and prints to stdout";
    platforms = lib.platforms.linux;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
