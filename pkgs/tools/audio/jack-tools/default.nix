{ stdenv, fetchgit, fetchdarcs, pkgconfig, libjack2, alsaLib, libGL, libGLU
,freeglut, libsndfile, libsamplerate, liblo, ncurses, libtool, xorg, asciidoc, libxslt, libxml2, libpng }:

let
  
srcs = {

  rju = fetchdarcs {
    url = http://rohandrape.net/sw/rju/;
    sha256 = "1h40hgmw51w2145xfng2dy0r5m5pl6mnl4hhwrajzfxc5g35hs31";
  };

  c-common = fetchdarcs {
    url = http://rohandrape.net/sw/c-common/;
    sha256 = "06rjlnhin99hgxh0h560q95szhzbvr7l4mn3x38q9704k7nzj3q4";
  };

};


in stdenv.mkDerivation rec {
  name = "jack-tools-${version}";
  version = "unstable-2018-09-2";

  src = srcs.rju;

  postUnpack = ''
    cp -r ${srcs.c-common} $sourceRoot/cmd/c-common
    chmod -R +rw $sourceRoot/cmd/c-common
  '';
 
 nativeBuildInputs = [
    pkgconfig
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
    libpng
  ];


  buildPhase = ''
    cd cmd/c-common
    make
    cd ../ 
    make jack-data 
    make jack-dl 
    make jack-osc 
    make jack-play 
    make jack-play-sc3 
    make jack-plumbing 
    make jack-record 
    make jack-scope 
    make jack-transport 
    make jack-udp 

  '';

  installPhase = ''
    mkdir -p $out/bin
    cp jack-data $out/bin
    cp jack-dl $out/bin
    cp jack-osc $out/bin
    cp jack-play $out/bin
    cp jack-play-sc3 $out/bin
    cp jack-plumbing $out/bin
    cp jack-record $out/bin
    cp jack-scope $out/bin
    cp jack-transport $out/bin
    cp jack-udp $out/bin

  '';

  meta = {
    homepage = http://rd.slavepianos.org/r/d/darcsweb.cgi?r=rju;
    description = "jackd utilities";
    license = stdenv.lib.licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ hark ];
    platforms = stdenv.lib.platforms.linux;

  };
}
