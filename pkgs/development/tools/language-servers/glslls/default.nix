{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, python3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glslls";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "glsl-language-server";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-wi1QiqaWRh1DmIhwmu94lL/4uuMv6DnB+whM61Jg1Zs=";
  };

  nativeBuildInputs = [
    python3
    cmake
    ninja
  ];

  meta = {
    description = "A language server implementation for GLSL";
    mainProgram = "glslls";
    homepage = "https://github.com/svenstaro/glsl-language-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ declan ];
    platforms = lib.platforms.linux;
  };
})
