{ stdenv, fetchurl, pkgconfig, bc, perl, pam, libXext, libXScrnSaver, libX11
, libXrandr, libXmu, libXxf86vm, libXrender, libXxf86misc, libjpeg, mesa, gtk
, libxml2, libglade, intltool
}:

stdenv.mkDerivation rec {
  version = "5.32";
  name = "xscreensaver-${version}";

  src = fetchurl {
    url = "http://www.jwz.org/xscreensaver/${name}.tar.gz";
    sha256 = "1gckra8lsd383av15r7lv9rszw6mp8n1gpcb5qs5nbrdkl3sclj2";
  };

  buildInputs =
    [ pkgconfig bc perl libjpeg mesa gtk libxml2 libglade pam
      libXext libXScrnSaver libX11 libXrandr libXmu libXxf86vm libXrender
      libXxf86misc intltool
    ];

  preConfigure =
    ''
      # Fix build error in version 5.18. Remove this patch when updating
      # to a later version.
      #sed -i -e '/AF_LINK/d' hacks/glx/sonar-icmp.c

      # Fix installation paths for GTK resources.
      sed -e 's%@GTK_DATADIR@%@datadir@% ; s%@PO_DATADIR@%@datadir@%' \
          -i driver/Makefile.in po/Makefile.in.in
    '';

  configureFlags =
    [ "--with-gl" "--with-pam" "--with-pixbuf" "--with-proc-interrupts"
      "--with-dpms-ext" "--with-randr-ext" "--with-xinerama-ext"
      "--with-xf86vmode-ext" "--with-xf86gamma-ext" "--with-randr-ext"
      "--with-xshm-ext" "--with-xdbe-ext" "--without-readdisplay"
      "--with-x-app-defaults=\${out}/share/xscreensaver/app-defaults"
    ];

  meta = {
    homepage = "http://www.jwz.org/xscreensaver/";
    description = "A set of screensavers";
    maintainers = with stdenv.lib.maintainers; [ raskin urkud ];
    platforms = with stdenv.lib.platforms; allBut cygwin;
    inherit version;
    downloadPage = "http://www.jwz.org/xscreensaver/download.html";
    updateWalker = true;
  };
}
