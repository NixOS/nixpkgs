{ stdenv, fetchurl, pkgconfig, zip, libtheora, xvidcore, libGLU_combined, SDL, SDL_image, SDL_ttf, SDL_mixer
, curl, libjpeg, libpng, gettext, cunit, enableEditor?false }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "ufoai";
  version = "2.5";
  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}-source.tar.bz2";
    sha256 = "13ra337mjc56kw31m7z77lc8vybngkzyhvmy3kvpdcpyksyc6z0c";
  };

  srcData = fetchurl {
    url = "mirror://sourceforge/${pname}/${name}-data.tar";
    sha256 = "1c6dglmm36qj522q1pzahxrqjkihsqlq2yac1aijwspz9916lw2y";
  };

  nativeBuildInputs = [ pkgconfig zip ];

  preConfigure = ''tar xvf "${srcData}"'';

  configureFlags = [ "--enable-release" "--enable-sse" ]
    ++ stdenv.lib.optional enableEditor "--enable-uforadiant";

  buildInputs = [
    libtheora xvidcore libGLU_combined SDL SDL_image SDL_mixer SDL_ttf
    curl libjpeg libpng gettext cunit
  ];

  CXXFLAGS = [ "-std=gnu++98" ];

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
