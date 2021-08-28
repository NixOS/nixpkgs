{ lib
, stdenv
, fetchurl
, meson
, ninja
, gobject-introspection
, gnutls
, cairo
, glib
, pkg-config
, cyrus_sasl
, libpulseaudio
, libgcrypt
, gtk3
, vala
, gettext
, perl
, gnome
, gdk-pixbuf
, zlib
}:

stdenv.mkDerivation rec {
  pname = "gtk-vnc";
  version = "1.2.0";

  outputs = [ "out" "bin" "man" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "0jmr6igyzcj2wmx5v5ywaazvdz3hx6a6rys26yb4l4s71l281bvs";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
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
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "GTK VNC widget";
    homepage = "https://wiki.gnome.org/Projects/gtk-vnc";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ raskin offline ];
    platforms = platforms.linux;
  };
}
