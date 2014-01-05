{ stdenv, fetchhg, zlib, bzip2, pkgconfig, alsaLib, pulseaudio, libmad, libtheora,
  libvorbis, libpng, libjpeg, mesa, gtk, ffmpeg, automake, autoconf, glew }:

stdenv.mkDerivation rec {
  name = "stepmania-5";

  src = fetchhg {
    url = "https://code.google.com/p/sm-ssc/";
    # revision = "5fdf515a180e";
    sha256 = "05v19giq7d956islr2r8350zfwc4h8sq89xlj93ccii8rp94cvvf";
  };

  buildInputs = [ zlib bzip2 pkgconfig alsaLib pulseaudio libmad libtheora
                  libvorbis libpng libjpeg mesa gtk ffmpeg automake autoconf glew ];

  preConfigure = "./autogen.sh";
  postInstall = ''
    mv "$out/stepmania 5/"* $out/
    rmdir "$out/stepmania 5"
    mkdir -p $out/bin
    echo "#\!/bin/sh" > $out/bin/stepmania
    echo 'export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${alsaLib}/lib' >> $out/bin/stepmania
    echo "exec $out/stepmania" >> $out/bin/stepmania
    chmod +x $out/bin/stepmania
  '';
}
