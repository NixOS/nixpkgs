{ stdenv, lib, fetchpatch, fetchFromGitHub, cmake, nasm
, gtk2, glib, ffmpeg, alsaLib, libmad, libogg, libvorbis
, glew, libpulseaudio, udev
}:

stdenv.mkDerivation rec {
  name = "stepmania-${version}";
  version = "5.0.12";

  src = fetchFromGitHub {
    owner = "stepmania";
    repo  = "stepmania";
    rev   = "v${version}";
    sha256 = "0ig5pnw78j45b35kfr76phaqbac9b2f6wg3c63l6mf0nrq17wslz";
  };

  nativeBuildInputs = [ cmake nasm ];

  buildInputs = [
    gtk2 glib ffmpeg alsaLib libmad libogg libvorbis
    glew libpulseaudio udev
  ];

  cmakeFlags = [
    "-DWITH_SYSTEM_FFMPEG=1"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
  ];

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/stepmania-5.0/stepmania $out/bin/stepmania
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = http://www.stepmania.com/;
    description = "Free dance and rhythm game for Windows, Mac, and Linux";
    platforms = platforms.linux;
    license = licenses.mit; # expat version
    maintainers = [ maintainers.mornfall ];
  };
}
