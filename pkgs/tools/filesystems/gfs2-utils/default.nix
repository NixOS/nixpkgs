{ lib, stdenv, fetchurl, fetchpatch
, autoreconfHook, bison, flex, pkg-config
, bzip2, check, ncurses, util-linux, zlib
}:

stdenv.mkDerivation rec {
  pname = "gfs2-utils";
  version = "3.4.1";

  src = fetchurl {
    url = "https://pagure.io/gfs2-utils/archive/${version}/gfs2-utils-${version}.tar.gz";
    sha256 = "sha256-gwKxBBG5PtG4/RxX4sUC25ZeG8K2urqVkFDKL7NS4ZI=";
  };

  patches = [
    # pull pending upstream inclusion fix for ncurses-6.3: sent upstream over email.
    (fetchpatch {
      name = "ncurses-6.3.patch";
      url = "https://pagure.io/fork/slyfox/gfs2-utils/c/c927b635f380cca77665195a3aaae804d92870a4.patch";
      sha256 = "sha256-0M1xAqRXoUi2el03WODF/nqEe9JEE5GehMWs776QZNI=";
    })
  ];
  postPatch = ''
    # Apply fix for ncurses-6.3. Upstream development branch already reworked the code.
    # To be removed on next reelase.
    substituteInPlace gfs2/edit/gfs2hex.c --replace 'printw(title);' 'printw("%s",title);'
  '';

  outputs = [ "bin" "doc" "out" "man" ];

  nativeBuildInputs = [ autoreconfHook bison flex pkg-config ];
  buildInputs = [ bzip2 ncurses util-linux zlib ];

  nativeCheckInputs = [ check ];
  doCheck = true;

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://pagure.io/gfs2-utils";
    description = "Tools for creating, checking and working with gfs2 filesystems";
    maintainers = with maintainers; [ qyliss ];
    license = [ licenses.gpl2Plus licenses.lgpl2Plus ];
    platforms = platforms.linux;
  };
}
