{stdenv, fetchurl, SDL, SDL_mixer, SDL_image, SDL_ttf, SDL_net, python } :

stdenv.mkDerivation rec {
  name = "tennix-1.1";
  src = fetchurl {
    url = "https://icculus.org/tennix/downloads/${name}.tar.gz";
    sha256 = "0np5kw1y7i0z0dsqx4r2nvmq86qj8hv3mmgavm3hxraqnds5z8cm";
  };

  buildInputs = [ python SDL SDL_mixer SDL_image SDL_ttf SDL_net ];

  patches = [ ./fix_FTBFS.patch ];

  preConfigure = ''
    makeFlags="PREFIX=$out"
    installFlags="PREFIX=$out install"
  '';

  meta = with stdenv.lib; {
    homepage = "http://icculus.org/tennix/";
    description = "Classic Championship Tour 2011";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ pSub ];
  };
}
