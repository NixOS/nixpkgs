{ lib, stdenv, fetchurl
# Build depends
, docutils, meson, ninja, pkg-config, python3
# Runtime depends
, glfw, SDL2, SDL2_mixer
, freetype, libpng, libwebp, libzip, zlib
}:

stdenv.mkDerivation rec {
  pname = "taisei";
  version = "1.3.1";

  src = fetchurl {
    url = "https://github.com/taisei-project/${pname}/releases/download/v${version}/${pname}-v${version}.tar.xz";
    sha256 = "11f9mlqmzy1lszwcc1nsbar9q1hs4ml6pbm52hqfd4q0f4x3ln46";
  };

  nativeBuildInputs = [
    docutils meson ninja pkg-config python3
  ];

  buildInputs = [
    glfw SDL2 SDL2_mixer
    freetype libpng libwebp libzip zlib
  ];

  patches = [ ./0001-lto-fix.patch ];

  preConfigure = ''
    patchShebangs .
  '';

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "A free and open-source Touhou Project clone and fangame";
    longDescription = ''
      Taisei is an open clone of the Tōhō Project series. Tōhō is a one-man
      project of shoot-em-up games set in an isolated world full of Japanese
      folklore.
    '';
    homepage = "https://taisei-project.org/";
    license = [ licenses.mit licenses.cc-by-40 ];
    maintainers = [ maintainers.lambda-11235 ];
    platforms = platforms.all;
  };
}

