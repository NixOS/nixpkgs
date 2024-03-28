{
  lib,
  stdenv,
  fetchFromGitHub,
  bzip2,
  cmake,
  curl,
  freetype,
  glew,
  libGLU,
  libogg,
  libpng,
  libvorbis,
  libXi,
  libXrandr,
  libXxf86vm,
  openal,
  which,
  zlib,
}:
stdenv.mkDerivation {
  pname = "starruler2-engine";
  version = "2022-05-27";

  src = fetchFromGitHub {
    owner = "OpenSRProject";
    repo = "OpenStarRuler";
    rev = "db86ab0c173abf4b5fba2a4acd8704b5fd9dfec5";
    hash = "sha256-FH2hWTdL1wNYjcsZ5kVD5qkJZ71BVtjg8QIiVY49K/A=";
  };

  nativeBuildInputs = [
    cmake
    which
  ];

  buildInputs = [
    bzip2
    curl
    freetype
    glew
    libGLU
    libogg
    libpng
    libvorbis
    libXi
    libXrandr
    libXxf86vm
    openal
    zlib
  ];

  NLTO = 1; # LTO fails in Nix.

  # CMake is only used for the nested GLFW build,
  # not the top-level build.
  dontUseCmakeConfigure = true;

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mv bin/lin64/StarRuler2.bin "$out/bin/starruler2"

    runHook postInstall
  '';

  meta = with lib; {
    description = "A massive-scale 4X/RTS game set in space -- engine";
    homepage = "https://github.com/OpenSRProject/OpenStarRuler";
    license = licenses.mit;
    # 32-bit Linux may be supported,
    # but will require testing
    # and changes to `installPhase`,
    # at the least.
    # Darwin may require upstream changes.
    platforms = ["x86_64-linux"];
    maintainers = with maintainers; [justinlovinger];
  };
}
