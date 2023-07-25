{ fetchurl, fetchpatch, lib, stdenv, libX11, xorgproto, libXext, libXtst
, gtk2, libXi, pkg-config, texinfo }:

stdenv.mkDerivation rec {
  version = "3.19";
  pname = "xnee";

  src = fetchurl {
    url = "mirror://gnu/xnee/${pname}-${version}.tar.gz";
    sha256 = "04n2lac0vgpv8zsn7nmb50hf3qb56pmj90dmwnivg09gyrf1x92j";
  };

  patches = [
    # Pull fix pending upstream inclusion for -fno-common
    # toolchain support: https://savannah.gnu.org/bugs/?58810
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://savannah.gnu.org/bugs/download.php?file_id=49534";
      sha256 = "04j2cjy2yaiigg31a6k01vw0fq19yj3zpriikkjcz9q4ab4m5gh2";
    })
  ];

  postPatch =
    '' for i in `find cnee/test -name \*.sh`
       do
         sed -i "$i" -e's|/bin/bash|${stdenv.shell}|g ; s|/usr/bin/env bash|${stdenv.shell}|g'
       done

       # Fix for glibc-2.34. For some reason, `LIBSEMA="CCC"` is added
       # if `sem_init` is part of libc which causes errors like
       # `gcc: error: CCC: No such file or directory` during the build.
       substituteInPlace configure \
        --replace 'LIBSEMA="CCC"' 'LIBSEMA=""'
    '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs =
    [ libX11 xorgproto libXext libXtst gtk2
      libXi
      texinfo
    ];

  configureFlags =
    # Do a static build because `libxnee' doesn't get installed anyway.
    [ "--disable-gnome-applet" "--enable-static" ];

  # `cnee' is linked without `-lXi' and as a consequence has a RUNPATH that
  # lacks libXi.
  makeFlags = [ "LDFLAGS=-lXi" ];

  # XXX: Actually tests require an X server.
  doCheck = true;

  meta = {
    description = "X11 event recording and replay tool";

    longDescription =
      '' Xnee is a suite of programs that can record, replay and distribute
         user actions under the X11 environment.  Think of it as a robot that
         can imitate the job you just did.  Xnee can be used to automate
         tests, demonstrate programs, distribute actions, record & replay
         "macros", retype a file.
      '';

    license = lib.licenses.gpl3Plus;

    homepage = "https://www.gnu.org/software/xnee/";

    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.gnu ++ lib.platforms.linux;  # arbitrary choice
  };
}
