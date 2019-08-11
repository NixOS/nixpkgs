{ fetchurl, stdenv, libX11, xorgproto, libXext, libXtst
, gtk2, libXi, pkgconfig, texinfo }:

stdenv.mkDerivation rec {
  version = "3.19";
  name = "xnee-${version}";

  src = fetchurl {
    url = "mirror://gnu/xnee/${name}.tar.gz";
    sha256 = "04n2lac0vgpv8zsn7nmb50hf3qb56pmj90dmwnivg09gyrf1x92j";
  };

  patchPhase =
    '' for i in `find cnee/test -name \*.sh`
       do
         sed -i "$i" -e's|/bin/bash|${stdenv.shell}|g ; s|/usr/bin/env bash|${stdenv.shell}|g'
       done
    '';

  buildInputs =
    [ libX11 xorgproto libXext libXtst gtk2
      libXi pkgconfig
      texinfo
    ];

  configureFlags =
    # Do a static build because `libxnee' doesn't get installed anyway.
    [ "--disable-gnome-applet" "--enable-static" ];

  # `cnee' is linked without `-lXi' and as a consequence has a RUNPATH that
  # lacks libXi.
  makeFlags = "LDFLAGS=-lXi";

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

    license = stdenv.lib.licenses.gpl3Plus;

    homepage = https://www.gnu.org/software/xnee/;

    maintainers = with stdenv.lib.maintainers; [ fuuzetsu ];
    platforms = stdenv.lib.platforms.gnu ++ stdenv.lib.platforms.linux;  # arbitrary choice
  };
}
