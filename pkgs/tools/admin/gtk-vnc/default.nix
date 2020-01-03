{ stdenv
, fetchurl
, fetchpatch
, meson
, ninja
, gobject-introspection
, gnutls
, cairo
, glib
, pkgconfig
, cyrus_sasl
, libpulseaudio
, libgcrypt
, gtk3
, vala
, gettext
, perl
, gnome3
, gdk-pixbuf
, zlib
}:

stdenv.mkDerivation rec {
  pname = "gtk-vnc";
  version = "1.0.0";

  outputs = [ "out" "bin" "man" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "1060ws037v556rx1qhfrcg02859rscksrzr8fq11himdg4d1y6m8";
  };

  patches = [
    # Fix undeclared gio-unix-2.0 in example program.
    (fetchpatch {
      url = "https://gitlab.gnome.org/GNOME/gtk-vnc/commit/8588bc1c8321152ddc5086ca9b2c03a7f511e0d0.patch";
      sha256 = "0i1iapsbngl1mhnz22dd73mnzk68qc4n51pqdhnm18zqc8pawvh4";
    })
  ];

  nativeBuildInputs = [
    meson
    ninja
    pkgconfig
    gobject-introspection
    vala
    gettext
    perl # for pod2man
  ];

  buildInputs = [
    gnutls
    cairo
    gdk-pixbuf
    zlib
    glib
    libgcrypt
    cyrus_sasl
    libpulseaudio
    gtk3
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    description = "GTK VNC widget";
    homepage = https://wiki.gnome.org/Projects/gtk-vnc;
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ raskin offline ];
    platforms = platforms.linux;
  };
}
