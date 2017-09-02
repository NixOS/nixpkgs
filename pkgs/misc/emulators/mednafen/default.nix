{ stdenv, fetchurl, pkgconfig
, libX11, mesa, freeglut
, libjack2, libcdio, libsndfile, libsamplerate
, SDL, SDL_net, zlib
}:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "mednafen-${version}";
  version = "0.9.47";

  src = fetchurl {
    url = "https://mednafen.github.io/releases/files/${name}.tar.xz";
    sha256 = "0flz6bjkzs9qrw923s4cpqrz4b2dhc2w7pd8mgw0l1xbmrh7w4si";
  };

  buildInputs =
  [ pkgconfig libX11 mesa freeglut libjack2 libcdio
    libsndfile libsamplerate SDL SDL_net zlib ];

  # Install docs
  postInstall = ''
    mkdir -p $out/share/doc/$name
    cd Documentation
    install -m 644 -t $out/share/doc/$name *.css *.def *.html *.php *.png *.txt
  '';

  meta = with stdenv.lib; {
    description = "A portable, CLI-driven, SDL+OpenGL-based, multi-system emulator";
    homepage = http://mednafen.github.io/;
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };
}
