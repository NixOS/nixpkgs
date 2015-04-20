{ fetchFromGitHub, stdenv, pkgconfig, autoconf, automake, yasm, zlib, bzip2, alsaLib
, pulseaudio, libmad, libtheora, libvorbis, libpng, libjpeg, gtk
, mesa, glew }:

stdenv.mkDerivation rec {
  name = "stepmania-${version}";
  version = "5.0.7";

  src = fetchFromGitHub {
    owner = "stepmania";
    repo  = "stepmania";
    rev   = "v${version}";
    sha256 = "1lagnk8x72v5jazcbb39237fi33kp5zgg22fxw7zmvr4qwqiqbz9";
  };

  buildInputs = [
    pkgconfig autoconf automake yasm zlib bzip2 alsaLib pulseaudio libmad libtheora
    libvorbis libpng libjpeg gtk mesa glew
  ];

  preConfigure = ''
    substituteInPlace autoconf/m4/video.m4 \
      --replace './configure $FFMPEG_CONFFLAGS' './configure --prefix='$out' $FFMPEG_CONFFLAGS'

    ./autogen.sh
  '';

  postInstall = ''
    mkdir -p $out/bin
    echo "#!/bin/sh" > $out/bin/stepmania
    echo "export LD_LIBRARY_PATH=$out/stepmania-5.0:${alsaLib}/lib:\$LD_LIBRARY_PATH" >> $out/bin/stepmania
    echo "exec $out/stepmania-5.0/stepmania" >> $out/bin/stepmania
    chmod +x $out/bin/stepmania
  '';

  meta = with stdenv.lib; {
      platforms = platforms.linux;
      maintainers = [ maintainers.mornfall ];
  };
}
