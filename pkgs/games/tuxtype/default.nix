{ lib, stdenv, fetchFromGitHub, autoreconfHook, pkg-config, librsvg, libxml2, SDL, SDL_image, SDL_mixer, SDL_net, SDL_ttf, t4kcommon }:

stdenv.mkDerivation rec {
  version = "1.8.3";
  pname = "tuxtype";

  src = fetchFromGitHub {
    owner = "tux4kids";
    repo = "tuxtype";
    rev = "upstream/${version}";
    sha256 = "1i33rhi9gpzfml4hd73s18h6p2s8zcr26va2vwf2pqqd9fhdwpsg";
  };

  postPatch = ''
    patchShebangs data/scripts/sed-linux.sh
    patchShebangs data/themes/asturian/scripts/sed-linux.sh
    patchShebangs data/themes/greek/scripts/sed-linux.sh
    patchShebangs data/themes/hungarian/scripts/sed-linux.sh

    substituteInPlace Makefile.am \
      --replace "\$(MKDIR_P) -m 2755 " "\$(MKDIR_P) -m 755 " \
      --replace "chown root:games \$(DESTDIR)\$(pkglocalstatedir)/words" " "

    # required until the following has been merged:
    # https://salsa.debian.org/tux4kids-pkg-team/tuxtype/merge_requests/1
    substituteInPlace configure.ac \
      --replace 'CFLAGS="$CFLAGS $SDL_IMAGE"' 'CFLAGS="$CFLAGS $SDL_IMAGE_CFLAGS"' \
      --replace 'PKG_CHECK_MODULES([SDL_ttf],' 'PKG_CHECK_MODULES([SDL_TTF],'
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config ];
  buildInputs = [ librsvg libxml2 SDL SDL_image SDL_mixer SDL_net SDL_ttf t4kcommon ];

  configureFlags = [ "--without-sdlpango" ];

  meta = with lib; {
    description = "An Educational Typing Tutor Game Starring Tux, the Linux Penguin";
    mainProgram = "tuxtype";
    homepage = "https://github.com/tux4kids/tuxtype";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.aanderse ];
    platforms = platforms.linux;
  };
}
