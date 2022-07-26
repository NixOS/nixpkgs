{lib, stdenv, fetchurl, fetchpatch, zlib, ncurses, fuse}:

stdenv.mkDerivation rec {
  pname = "wiimms-iso-tools";
  version = "3.02a";

  src = fetchurl {
    url = "https://download.wiimm.de/source/wiimms-iso-tools/wiimms-iso-tools.source-${version}.tar.bz2";
    sha256 = "074cvcaqz23xyihslc6n64wwxwcnl6xp7l0750yb9pc0wrqxmj69";
  };

  buildInputs = [ zlib ncurses fuse ];

  patches = [
    ./fix-paths.diff

    # Pull pending upstream fix for ncurses-6.3:
    #  https://github.com/Wiimm/wiimms-iso-tools/pull/14
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://github.com/Wiimm/wiimms-iso-tools/commit/3f1e84ec6915cc4f658092d33411985bd3eaf4e6.patch";
      sha256 = "18cfri4y1082phg6fzh402gk5ri24wr8ff4zl8v5rlgjndh610im";
      stripLen = 1;
    })
  ];

  postPatch = ''
    patchShebangs setup.sh
    patchShebangs gen-template.sh
    patchShebangs gen-text-file.sh
  '';

  # Workaround build failure on -fno-common toolchains like upstream gcc-10.
  NIX_CFLAGS_COMPILE = "-Wno-error=format-security -fcommon";
  INSTALL_PATH = "$out";

  installPhase = ''
    mkdir "$out"
    patchShebangs install.sh
    ./install.sh --no-sudo
  '';

  meta = with lib; {
    homepage = "https://wit.wiimm.de";
    description = "A set of command line tools to manipulate Wii and GameCube ISO images and WBFS containers";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ nilp0inter ];
  };
}
