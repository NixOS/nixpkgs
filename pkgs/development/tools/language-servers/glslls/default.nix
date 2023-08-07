{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, python3
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glslls";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "svenstaro";
    repo = "glsl-language-server";
    rev = finalAttrs.version;
    fetchSubmodules = true;
    hash = "sha256-UgQXxme0uySKYhhVMOO7+EZ4BL2s8nmq9QxC2SFQqRg=";
  };

  nativeBuildInputs = [
    python3
    cmake
    ninja
  ];

  meta = {
    description = "A language server implementation for GLSL";
    homepage = "https://github.com/svenstaro/glsl-language-server";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ declan ];
    platforms = lib.platforms.linux;
  };
})
