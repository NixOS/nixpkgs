{ lib, stdenv, fetchurl, pkg-config, gtk, openssl }:

stdenv.mkDerivation rec {
  pname = "macopix";
  version = "1.7.4";

  src = fetchurl {
    url = "http://rosegray.sakura.ne.jp/macopix/macopix-${version}.tar.bz2";
    sha256 = "0sgnr0wrw3hglcnsyvipll7icfv69ssmyw584zfhk1rgramlkzyb";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk openssl ];

  preConfigure = ''
    # Build fails on Linux with windres.
    export ac_cv_prog_WINDRES=
  '';

  enableParallelBuilding = true;

  # Workaround build failure on -fno-common toolchains:
  #   ld: dnd.o:src/main.h:136: multiple definition of
  #     `MENU_EXT'; main.o:src/main.h:136: first defined here
  env.NIX_CFLAGS_COMPILE = "-fcommon";

  NIX_LDFLAGS = "-lX11";

  meta = {
    description = "Mascot Constructive Pilot for X";
    homepage = "http://rosegray.sakura.ne.jp/macopix/index-e.html";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
  };
}
