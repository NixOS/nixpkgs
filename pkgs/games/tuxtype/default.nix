{ stdenv, fetchurl, pkgconfig, librsvg, SDL, SDL_image, SDL_mixer, SDL_ttf }:

stdenv.mkDerivation rec {
  version = "1.8.3";
  name = "tuxtype-${version}";

  src = fetchurl {
    url = "https://github.com/tux4kids/tuxtype/archive/upstream/${version}.tar.gz";
    sha256 = "0cv935ir14cd2c8bgsxxpi6id04f61170gslakmwhxn6r3pbw0lp";
  };

  patchPhase = ''
    patchShebangs data/scripts/sed-linux.sh
    patchShebangs data/themes/asturian/scripts/sed-linux.sh
    patchShebangs data/themes/greek/scripts/sed-linux.sh
    patchShebangs data/themes/hungarian/scripts/sed-linux.sh

    substituteInPlace Makefile.am \
      --replace "\$(MKDIR_P) -m 2755 " "\$(MKDIR_P) -m 755 " \
      --replace "chown root:games \$(DESTDIR)\$(pkglocalstatedir)/words" " "

    substituteInPlace Makefile.in \
      --replace "\$(MKDIR_P) -m 2755 " "\$(MKDIR_P) -m 755 " \
      --replace "chown root:games \$(DESTDIR)\$(pkglocalstatedir)/words" " "
  '';

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ librsvg SDL SDL_image SDL_mixer SDL_ttf ];

  configureFlags = [ "--without-sdlpango" ];

  meta = with stdenv.lib; {
    description = "An Educational Typing Tutor Game Starring Tux, the Linux Penguin";
    homepage = https://github.com/tux4kids/tuxtype;
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.aanderse ];
    platforms = platforms.linux;
  };
}
