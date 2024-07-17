{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  gtk2,
  libX11,
  libXext,
  libXi,
  libXtst,
  texinfo,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "3.19";
  pname = "xnee";

  src = fetchurl {
    url = "mirror://gnu/xnee/xnee-${finalAttrs.version}.tar.gz";
    hash = "sha256-UqQeXPYvgbej5bWBJOs1ZeHhICir2mP1R/u+DZiiwhI=";
  };

  patches = [
    # Pull fix pending upstream inclusion for -fno-common
    # toolchain support: https://savannah.gnu.org/bugs/?58810
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://savannah.gnu.org/bugs/download.php?file_id=49534";
      hash = "sha256-Ar5SyVIEp8/knDHm+4f0KWAH+A5gGhXGezEqL7xkQhI=";
    })
  ];

  postPatch =
    ''
      for i in `find cnee/test -name \*.sh`; do
        sed -i "$i" -e's|/bin/bash|${stdenv.shell}|g ; s|/usr/bin/env bash|${stdenv.shell}|g'
      done
    ''
    # Fix for glibc-2.34. For some reason, `LIBSEMA="CCC"` is added
    # if `sem_init` is part of libc which causes errors like
    # `gcc: error: CCC: No such file or directory` during the build.
    + ''
      substituteInPlace configure* \
        --replace 'LIBSEMA="CCC"' 'LIBSEMA=""'
    '';

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    gtk2
    libX11
    libXext
    libXi
    libXtst
    texinfo
    xorgproto
  ];

  configureFlags = [
    "--disable-gnome-applet"
    # Do a static build because `libxnee' doesn't get installed anyway.
    "--enable-static"
  ];

  makeFlags = [
    # `cnee' is linked without `-lXi' and as a consequence has a RUNPATH that
    # lacks libXi.
    "LDFLAGS=-lXi"
  ];

  # error: call to undeclared function 'xnee_check_key';
  # ISO C99 and later do not support implicit function declarations
  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  # XXX: Actually tests require an X server.
  doCheck = true;

  meta = {
    description = "X11 event recording and replay tool";
    longDescription = ''
      Xnee is a suite of programs that can record, replay and distribute
      user actions under the X11 environment.  Think of it as a robot that
      can imitate the job you just did.  Xnee can be used to automate
      tests, demonstrate programs, distribute actions, record & replay
      "macros", retype a file.
    '';
    homepage = "https://www.gnu.org/software/xnee/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ wegank ];
    platforms = lib.platforms.unix;
  };
})
