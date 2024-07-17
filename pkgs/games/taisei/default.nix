{
  lib,
  stdenv,
  fetchurl,
  # Build depends
  docutils,
  meson,
  ninja,
  pkg-config,
  python3,
  # Runtime depends
  glfw,
  SDL2,
  SDL2_mixer,
  cglm,
  freetype,
  libpng,
  libwebp,
  libzip,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "taisei";
  version = "1.3.2";

  src = fetchurl {
    url = "https://github.com/taisei-project/${pname}/releases/download/v${version}/${pname}-v${version}.tar.xz";
    sha256 = "1g53fcyrlzmvlsb40pw90gaglysv6n1w42hk263iv61ibhdmzh6v";
  };

  nativeBuildInputs = [
    docutils
    meson
    ninja
    pkg-config
    python3
  ];

  buildInputs = [
    glfw
    SDL2
    SDL2_mixer
    cglm
    freetype
    libpng
    libwebp
    libzip
    zlib
  ];

  patches = [ ./0001-lto-fix.patch ];

  preConfigure = ''
    patchShebangs .
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Free and open-source Touhou Project clone and fangame";
    mainProgram = "taisei";
    longDescription = ''
      Taisei is an open clone of the Tōhō Project series. Tōhō is a one-man
      project of shoot-em-up games set in an isolated world full of Japanese
      folklore.
    '';
    homepage = "https://taisei-project.org/";
    license = [
      licenses.mit
      licenses.cc-by-40
    ];
    maintainers = [ maintainers.lambda-11235 ];
    platforms = platforms.all;
  };
}
