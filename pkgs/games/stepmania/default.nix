{ stdenv, lib, fetchpatch, fetchFromGitHub, cmake, nasm
, gtk2, glib, ffmpeg, alsaLib, libmad, libogg, libvorbis
, glew, libpulseaudio
}:

stdenv.mkDerivation rec {
  name = "stepmania-${version}";
  version = "5.0.10";

  src = fetchFromGitHub {
    owner = "stepmania";
    repo  = "stepmania";
    rev   = "v${version}";
    sha256 = "174gzvk42gwm56hpkz51csad9xi4dg466xv0mf1z39xd7mqd5j5w";
  };

  nativeBuildInputs = [ cmake nasm ];

  buildInputs = [
    gtk2 glib ffmpeg alsaLib libmad libogg libvorbis
    glew libpulseaudio
  ];

  cmakeFlags = [
    "-DWITH_SYSTEM_FFMPEG=1"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk2.out}/lib/gtk-2.0/include"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib.out}/lib/glib-2.0/include"
  ];

  patches = [
    # Fix compilation on i686
    (fetchpatch {
      url = "https://github.com/stepmania/stepmania/commit/f1e114aa03c90884946427bb43a75badec21f163.patch";
      sha256 = "1cm14w92dilqvlyqfffiihf09ra97hxzgfal5gx08brc3j1yyzdw";
    })
  ];

  postInstall = ''
    mkdir -p $out/bin
    ln -s $out/stepmania-5.0/stepmania $out/bin/stepmania
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://www.stepmania.com/";
    description = "Free dance and rhythm game for Windows, Mac, and Linux";
    platforms = platforms.linux;
    license = licenses.mit; # expat version
    maintainers = [ maintainers.mornfall ];
  };
}
