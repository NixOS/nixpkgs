{ stdenv, fetchurl
# Build depends
, docutils, meson, ninja, pkgconfig, python3
# Runtime depends
, glfw, SDL2, SDL2_mixer
, freetype, libpng, libwebp, libzip, zlib
}:

stdenv.mkDerivation rec {
  pname = "taisei";
  version = "1.3";

  src = fetchurl {
    url = "https://github.com/taisei-project/${pname}/releases/download/v${version}/${pname}-v${version}.tar.xz";
    sha256 = "0fl41cbjr8h6gmhc27l44cfkcnhg5c10b4fcfvnfsbjii8gdwvjd";
  };

  nativeBuildInputs = [
    docutils meson ninja pkgconfig python3
  ];

  buildInputs = [
    glfw SDL2 SDL2_mixer
    freetype libpng libwebp libzip zlib
  ];

  patches = [ ./0001-lto-fix.patch ];

  preConfigure = ''
    patchShebangs .
  '';

  meta = with stdenv.lib; {
    description = "A free and open-source Touhou Project clone and fangame";
    longDescription = ''
      Taisei is an open clone of the Tōhō Project series. Tōhō is a one-man
      project of shoot-em-up games set in an isolated world full of Japanese
      folklore.
    '';
    homepage = https://taisei-project.org/;
    license = [ licenses.mit licenses.cc-by-40 ];
    maintainers = [ maintainers.lambda-11235 ];
    platforms = platforms.all;
  };
}

