{ stdenv, fetchurl, pkgconfig
, libX11, mesa, freeglut
, libjack2, libcdio, libsndfile, libsamplerate
, SDL, SDL_net, zlib
}:

stdenv.mkDerivation rec {

  name = "mednafen-${version}";
  version = "0.9.38.5";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/mednafen/Mednafen/${version}/${name}.tar.bz2";
    sha256 = "1s1qwwlhkxr0vhzvlc1m0ib9lj7cws3cldm2mbjz4b421nxfdi8h";
  };

  buildInputs = with stdenv.lib;
  [ pkgconfig libX11 mesa freeglut libjack2 libcdio libsndfile libsamplerate SDL SDL_net zlib ];
  

  # Install docs
  postInstall = ''
    mkdir -p $out/share/doc/$name
    cd Documentation
    install -m 644 -t $out/share/doc/$name *.css *.def *.html *.php *.png *.txt
  '';

  meta = with stdenv.lib; {
    description = "A portable, CLI-driven, SDL+OpenGL-based, multi-system emulator";
    homepage = http://mednafen.sourceforge.net/;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
