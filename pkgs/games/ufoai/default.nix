{ lib, stdenv, fetchurl, libtheora, xvidcore, libGLU, libGL, SDL, SDL_ttf, SDL_mixer
, curl, libjpeg, libpng, gettext, cunit, enableEditor?false }:

stdenv.mkDerivation rec {
  pname = "ufoai";
  version = "2.4";
  src = fetchurl {
    url = "mirror://sourceforge/ufoai/ufoai-${version}-source.tar.bz2";
    sha256 = "0kxrbcjrharcwz319s90m789i4my9285ihp5ax6kfhgif2vn2ji5";
  };

  srcData = fetchurl {
    url = "mirror://sourceforge/ufoai/ufoai-${version}-data.tar";
    sha256 = "1drhh08cqqkwv1yz3z4ngkplr23pqqrdx6cp8c3isy320gy25cvb";
  };

  preConfigure = ''tar xvf "${srcData}"'';

  configureFlags = [ "--enable-release" "--enable-sse" ]
    ++ lib.optional enableEditor "--enable-uforadiant";

  buildInputs = [
    libtheora xvidcore libGLU libGL SDL SDL_ttf SDL_mixer
    curl libjpeg libpng gettext cunit
  ];

  NIX_CFLAGS_LINK = [
    # to avoid occasional runtime error in finding libgcc_s.so.1
    "-lgcc_s"
    # tests are underlinked against libm:
    # ld: release-linux-x86_64/testall/client/sound/s_mix.c.o: undefined reference to symbol 'acos@@GLIBC_2.2.5'
    "-lm"
  ];

  meta = {
    homepage = "http://ufoai.org";
    description = "A squad-based tactical strategy game in the tradition of X-Com";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [viric];
    platforms = lib.platforms.linux;
    hydraPlatforms = [];
  };
}
