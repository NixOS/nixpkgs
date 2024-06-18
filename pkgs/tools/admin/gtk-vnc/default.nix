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
, pulseaudioSupport ? stdenv.isLinux
, libpulseaudio
, libgcrypt
, gtk3
, vala
, gettext
, perl
, python3
, gnome
, gdk-pixbuf
, zlib
}:

stdenv.mkDerivation rec {
  pname = "gtk-vnc";
  version = "1.3.1";

  outputs = [ "out" "bin" "man" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "USdjrE4FWdAVi2aCyl3Ro71jPwgvXkNJ1xWOa1+A8c4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    gettext
    perl # for pod2man
    python3
  ];

  buildInputs = [
    gnutls
    cairo
    gdk-pixbuf
    zlib
    glib
    libgcrypt
    cyrus_sasl
    gtk3
  ] ++ lib.optionals pulseaudioSupport [
    libpulseaudio
  ];

  mesonFlags = lib.optionals (!pulseaudioSupport) [
    "-Dpulseaudio=disabled"
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
      versionPolicy = "none";
    };
  };

  meta = with lib; {
    description = "GTK VNC widget";
    homepage = "https://gitlab.gnome.org/GNOME/gtk-vnc";
    license = licenses.lgpl2Plus;
    maintainers = with maintainers; [ raskin offline ];
    platforms = platforms.unix;
    mainProgram = "gvnccapture";
  };
}
