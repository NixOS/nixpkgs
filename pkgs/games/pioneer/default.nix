{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, assimp
, curl
, freetype
#, glew
, libGL
, libGLU
, libpng
, libsigcxx
, libvorbis
, lua5_2
, mesa
, SDL2
, SDL2_image
}:

stdenv.mkDerivation rec {
  pname = "pioneer";
  version = "20240314";

  src = fetchFromGitHub{
    owner = "pioneerspacesim";
    repo = "pioneer";
    rev = version;
    hash = "sha256-CUaiQPRufo8Ng70w5KWlLugySMaTaUuZno/ckyU1w2w=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace 'string(TIMESTAMP PROJECT_VERSION "%Y%m%d")' 'set(PROJECT_VERSION ${version})'
  '';

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    assimp
    curl
    freetype
    libGL
    libGLU
    libpng
    libsigcxx
    libvorbis
    lua5_2
    mesa
    SDL2
    SDL2_image
  ];

  cmakeFlags = [
    "-DPIONEER_DATA_DIR:PATH=${placeholder "out"}/share/pioneer/data"
    "-DUSE_SYSTEM_LIBLUA:BOOL=YES"
  ];

  makeFlags = [ "all" "build-data" ];

  meta = with lib; {
    description = "A space adventure game set in the Milky Way galaxy at the turn of the 31st century";
    homepage = "https://pioneerspacesim.net";
    license = with licenses; [
        gpl3Only cc-by-sa-30
    ];
    platforms = [ "x86_64-linux" "i686-linux" ];
  };
}
