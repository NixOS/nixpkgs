{ stdenv, fetchgit, pkgconfig, libjack2, alsaLib, libGL, libGLU
,freeglut, libsndfile, libsamplerate, liblo, ncurses, libtool, xorg, asciidoc, libxslt, libxml2 }:

stdenv.mkDerivation rec {
  name = "jack-tools-${version}";
  version = "20131226";

  src = fetchgit {
    url    = https://salsa.debian.org/multimedia-team/jack-tools.git;
    rev    = "6f2a666d6859e7ef764145a73bdd5985ff850173";
    sha256 = "003pnyqbhncal5azf8qznz34mja4ywbgbmfkdfyizz12j4awscw4";
  };


#  nativeBuildInputs = [ pkgconfig ];
 
 buildInputs = [
    libjack2
    alsaLib
    libGL
    libGLU
    freeglut
    libsndfile
    libsamplerate
    liblo
    ncurses
    libtool
    xorg.libXext
    xorg.libXt
    asciidoc
    libxslt
    libxml2 
  ];

#  NIX_CFLAGS_COMPILE = "-fpermissive";

#  configureFlags = [
#    "--with-faac-prefix=${faac}"
#    "--with-lame-prefix=${lame.lib}"
#  ];

  buildPhase = ''
    make mk-local-c-common
    make
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp jack-dl $out/bin
    cp jack-osc $out/bin
    cp jack-play $out/bin
    cp jack-plumbing $out/bin
    cp jack-record $out/bin
    cp jack-scope $out/bin
    cp jack-transport $out/bin
    cp jack-udp $out/bin
    cp jack-dl $out/bin


  '';

 patches = [ ./jack-tools-curses.patch ];

#  enableParallelBuilding = true;

  meta = {
    homepage = http://rd.slavepianos.org/r/d/darcsweb.cgi?r=rju;
    description = "jackd utilities";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ hark ];
  };
}
