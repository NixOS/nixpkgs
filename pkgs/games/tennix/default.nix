{stdenv, fetchurl, SDL, SDL_mixer, SDL_image, SDL_ttf} :

stdenv.mkDerivation rec {
  name = "tennix-1.0";
  src = fetchurl {
    url = "http://icculus.org/tennix/downloads/${name}.tar.gz";
    sha256 = "18rd7h1j5skpkh037misixw9gigzc7qy13vrnrs21rphcfxzpifn";
  };


  preConfigure = ''
    makeFlags="PREFIX=$out USE_PYTHON=0"
    installFlags="PREFIX=$out install"
  '';

  buildInputs = [ SDL SDL_mixer SDL_image SDL_ttf ];

  meta = {
    homepage = http://icculus.org/tennix/;
    description = "Tennix 2009 World Tennis Championship Tour";
    license = "GPLv2+";
  };
}
