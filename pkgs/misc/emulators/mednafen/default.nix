{ stdenv, fetchurl, pkgconfig
, libX11, mesa, freeglut
, jack2, libcdio, libsndfile, libsamplerate
, SDL, SDL_net, zlib
}:

stdenv.mkDerivation rec {

  name = "mednafen-${version}";
  version = "0.9.36.3";

  src = fetchurl {
    url = "http://downloads.sourceforge.net/project/mednafen/Mednafen/${version}/${name}.tar.bz2";
    sha256 = "00byql2p28l4476mvzmv5ysclb6yv9f4qrf6vz0x7ii648rp97in";
  };

  buildInputs = with stdenv.lib;
  [ pkgconfig libX11 mesa freeglut jack2 libcdio libsndfile libsamplerate SDL SDL_net zlib ];
  

  # Install docs
  postInstall = ''
    mkdir -p $out/share/doc/$name
    cd Documentation
    install -m 644 -t $out/share/doc/$name *.css *.def *.html *.php *.png *.txt
  '';

  meta = {
    description = "A portable, CLI-driven, SDL+OpenGL-based, multi-system emulator";
    homepage = http://mednafen.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.AndersonTorres ];
    platforms = stdenv.lib.platforms.linux;
  };
}
