{ stdenv, fetchurl, pkgconfig
, libX11, mesa, freeglut
, jackaudio, libcdio, libsndfile, libsamplerate
, SDL, SDL_net, zlib
}:

stdenv.mkDerivation rec {

  name = "mednafen-${version}";
  version = "0.9.34.1";

  src = fetchurl {
    url = "http://sourceforge.net/projects/mednafen/files/Mednafen/${version}/${name}.tar.bz2";
    sha256 = "1d783ws5rpx6r8qk1l9nksx3kahbalis606psk4067bvfzy7kjb9";
  };

  buildInputs = with stdenv.lib;
  [ libX11 mesa freeglut jackaudio libcdio libsndfile libsamplerate SDL SDL_net zlib ];
  
  nativeBuildInputs = [ pkgconfig ];

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
