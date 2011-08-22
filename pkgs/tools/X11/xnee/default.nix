{ fetchurl, stdenv, libX11, xproto, libXext, xextproto, libXtst
, gtk, libXi, inputproto, pkgconfig, recordproto, texinfo }:

stdenv.mkDerivation rec {
  name = "xnee-3.10";

  src = fetchurl {
    url = "mirror://gnu/xnee/${name}.tar.gz";
    sha256 = "0mkbp0gikm1mv9g2v0vs7krinkz392p1crvaira8ml9q94py0q32";
  };

  patchPhase =
    '' for i in `find cnee/test -name \*.sh`
       do
         sed -i "$i" -e's|/bin/bash|/bin/sh|g ; s|/usr/bin/env bash|/bin/sh|g'
       done
    '';

  buildInputs =
    [ libX11 xproto libXext xextproto libXtst gtk
      libXi inputproto pkgconfig recordproto
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
    description = "GNU Xnee, an X11 event recording and replay tool";

    longDescription =
      '' Xnee is a suite of programs that can record, replay and distribute
         user actions under the X11 environment.  Think of it as a robot that
         can imitate the job you just did.  Xnee can be used to automate
         tests, demonstrate programs, distribute actions, record & replay
         "macros", retype a file.
      '';

    license = "GPLv3+";

    homepage = http://www.gnu.org/software/xnee/;

    maintainers = [ stdenv.lib.maintainers.ludo ];
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
  };
}
