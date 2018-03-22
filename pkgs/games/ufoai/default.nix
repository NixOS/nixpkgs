{ stdenv, fetchurl, libtheora, xvidcore, libGLU_combined, SDL, SDL_ttf, SDL_mixer
, curl, libjpeg, libpng, gettext, cunit, enableEditor?false }:

stdenv.mkDerivation rec {
  name = "ufoai-2.4";
  src = fetchurl {
    url = "mirror://sourceforge/ufoai/${name}-source.tar.bz2";
    sha256 = "0kxrbcjrharcwz319s90m789i4my9285ihp5ax6kfhgif2vn2ji5";
  };

  srcData = fetchurl {
    url = "mirror://sourceforge/ufoai/${name}-data.tar";
    sha256 = "1drhh08cqqkwv1yz3z4ngkplr23pqqrdx6cp8c3isy320gy25cvb";
  };

  preConfigure = ''tar xvf "${srcData}"'';

  configureFlags = [ "--enable-release" "--enable-sse" ]
    ++ stdenv.lib.optional enableEditor "--enable-uforadiant";

  buildInputs = [
    libtheora xvidcore libGLU_combined SDL SDL_ttf SDL_mixer
    curl libjpeg libpng gettext cunit
  ];

  NIX_CFLAGS_LINK = "-lgcc_s"; # to avoid occasional runtime error in finding libgcc_s.so.1

  meta = {
    homepage = http://ufoai.org;
    description = "A squad-based tactical strategy game in the tradition of X-Com";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = stdenv.lib.platforms.linux;
    hydraPlatforms = [];
  };
}
