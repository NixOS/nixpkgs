{ stdenv, fetchurl, pkgconfig, bc, perl, pam
, libXext, libXScrnSaver, libX11, libXrandr, libXmu, libXxf86vm, libXrender
, libXxf86misc
, libjpeg, mesa, gtk, libxml2, libglade
}:

stdenv.mkDerivation rec {
  version = "5.15";
  name = "xscreensaver-${version}";

  src = fetchurl {
    url = "http://www.jwz.org/xscreensaver/${name}.tar.gz";
    sha256 = "4f6d1f1e4c15dbb74e2296f8fe57a73d47d602515178c248bbc838f779d5082d";
  };

  buildInputs =
    [ pkgconfig bc perl libjpeg mesa gtk libxml2 libglade pam
      libXext libXScrnSaver libX11 libXrandr libXmu libXxf86vm libXrender
      libXxf86misc
    ];

  configureFlags =
    [ "--with-gl" "--with-pam" "--with-pixbuf" "--with-proc-interrupts"
      "--with-dpms-ext" "--with-randr-ext" "--with-xinerama-ext"
      "--with-xf86vmode-ext" "--with-xf86gamma-ext" "--with-randr-ext"
      "--with-xshm-ext" "--with-xdbe-ext" "--without-readdisplay"
      "--with-x-app-defaults=\${out}/share/xscreensaver/app-defaults"
    ];

  preConfigure =
    ''
      sed -e 's%@GTK_DATADIR@%@datadir@% ; s%@PO_DATADIR@%@datadir@%' \
        -i driver/Makefile.in po/Makefile.in.in
    '';

  meta = {
    homepage = "http://www.jwz.org/xscreensaver/";
    description = "A set of screensavers";
    maintainers = with stdenv.lib.maintainers; [ raskin urkud ];
    platforms = stdenv.lib.platforms.allBut "i686-cygwin";
  };
}
