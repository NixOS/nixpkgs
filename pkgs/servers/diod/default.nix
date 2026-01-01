{
  lib,
  stdenv,
<<<<<<< HEAD
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
=======
  fetchurl,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  munge,
  lua,
  libcap,
  perl,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "diod";
<<<<<<< HEAD
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "chaos";
    repo = "diod";
    tag = "v${version}";
    hash = "sha256-Fz+qvgw5ipyAcZlWBGkmSHuGrZ95i5OorLN3dkdsYKU=";
  };

  postPatch = ''
    sed -i configure.ac -e '/git describe/c ${version})'
  '';

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

=======
  version = "1.0.24";

  src = fetchurl {
    url = "https://github.com/chaos/diod/releases/download/${version}/${pname}-${version}.tar.gz";
    sha256 = "17wckwfsqj61yixz53nwkc35z66arb1x3napahpi64m7q68jn7gl";
  };

  postPatch = ''
    substituteInPlace diod/xattr.c --replace attr/xattr.h sys/xattr.h
    sed -i -e '/sys\/types\.h>/a #include <sys/sysmacros.h>' diod/ops.c
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  buildInputs = [
    munge
    lua
    libcap
    perl
    ncurses
  ];

<<<<<<< HEAD
  configureFlags = [
    "--with-systemdsystemunitdir=$(out)/lib/systemd/system/"
    "--sysconfdir=/etc"
  ];

  meta = {
    description = "I/O forwarding server that implements a variant of the 9P protocol";
    maintainers = with lib.maintainers; [ rnhmjoj ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Plus;
=======
  meta = with lib; {
    description = "I/O forwarding server that implements a variant of the 9P protocol";
    maintainers = with maintainers; [ rnhmjoj ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
