{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, cmake
, nasm
, alsa-lib
, ffmpeg_6
, glew
, glib
, gtk2
, libmad
, libogg
, libpng
, libpulseaudio
, libvorbis
, udev
, xorg
}:

stdenv.mkDerivation {
  pname = "stepmania";
  version = "5.1.0-b2-unstable-2022-11-14";

  src = fetchFromGitHub {
    owner = "stepmania";
    repo  = "stepmania";
    rev   = "d55acb1ba26f1c5b5e3048d6d6c0bd116625216f";
    hash = "sha256-49H2Q61R4l/G0fWsjCjiAUXeWwG3lcsDpV5XvR3l3QE=";
  };

  patches = [
    # https://github.com/stepmania/stepmania/pull/2247
    (fetchpatch {
      name = "fix-building-with-ffmpeg6.patch";
      url = "https://github.com/stepmania/stepmania/commit/3fef5ef60b7674d6431f4e1e4ba8c69b0c21c023.patch";
      hash = "sha256-m+5sP+mIpcSjioRBdzChqja5zwNcwdSNAfvSJ2Lww+g=";
    })
  ];

  postPatch = ''
    sed '1i#include <ctime>' -i src/arch/ArchHooks/ArchHooks.h # gcc12
  '';

  nativeBuildInputs = [ cmake nasm ];

  buildInputs = [
    alsa-lib
    ffmpeg_6
    glew
    glib
    gtk2
    libmad
    libogg
    libpng
    libpulseaudio
    libvorbis
    udev
    xorg.libXtst
  ];

  cmakeFlags = [
    "-DWITH_SYSTEM_FFMPEG=1"
    "-DWITH_SYSTEM_PNG=on"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
  ];

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/stepmania-5.1/stepmania $out/bin/stepmania

    mkdir -p $out/share/
    cp -r $src/icons $out/share/

    install -Dm444 $src/stepmania.desktop -t $out/share/applications
  '';

  meta = with lib; {
    homepage = "https://www.stepmania.com/";
    description = "Free dance and rhythm game for Windows, Mac, and Linux";
    platforms = platforms.linux;
    license = licenses.mit; # expat version
    maintainers = with maintainers; [ h7x4 ];
    mainProgram = "stepmania";
  };
}
