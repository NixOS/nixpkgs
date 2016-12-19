{ stdenv, fetchurl, pkgconfig
, libX11, mesa, freeglut
, libjack2, libcdio, libsndfile, libsamplerate
, SDL, SDL_net, zlib
}:

stdenv.mkDerivation rec {

  name = "mednafen-${meta.version}";

  src = fetchurl {
    url = "http://mednafen.fobby.net/releases/files/${name}.tar.bz2";
    sha256 = "1n6y7b86sv11vd6rv8if3wr4qyihkjai9km1s4smqcisi3pvxcqv";
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
    version = "0.9.38.7";
    description = "A portable, CLI-driven, SDL+OpenGL-based, multi-system emulator";
    homepage = http://mednafen.sourceforge.net/;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
