{ stdenv, lib, fetchFromGitHub, cmake, nasm
, gtk2, glib, ffmpeg, alsa-lib, libmad, libogg, libvorbis
, glew, libpulseaudio, udev
}:

stdenv.mkDerivation rec {
  pname = "stepmania";
  version = "5.1.0-b2";

  src = fetchFromGitHub {
    owner = "stepmania";
    repo  = "stepmania";
    rev   = "v${version}";
    sha256 = "0a7y9l7xm510vgnpmj1is7p9m6d6yd0fcaxrjcickz295k5w3rdn";
  };

  patches = [
    ./0001-fix-build-with-ffmpeg-4.patch
  ];

  postPatch = ''
    sed '1i#include <ctime>' -i src/arch/ArchHooks/ArchHooks.h # gcc12
  '';

  nativeBuildInputs = [ cmake nasm ];

  buildInputs = [
    gtk2 glib ffmpeg alsa-lib libmad libogg libvorbis
    glew libpulseaudio udev
  ];

  cmakeFlags = [
    "-DWITH_SYSTEM_FFMPEG=1"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
  ];

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/stepmania-5.1/stepmania $out/bin/stepmania
  '';

  meta = with lib; {
    homepage = "https://www.stepmania.com/";
    description = "Free dance and rhythm game for Windows, Mac, and Linux";
    platforms = platforms.linux;
    license = licenses.mit; # expat version
    maintainers = [ ];
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.isLinux && stdenv.isAarch64;
  };
}
