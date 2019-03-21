{ stdenv, fetchurl, gobject-introspection
, gnutls, cairo, libtool, glib, pkgconfig
, cyrus_sasl, intltool, libpulseaudio
, libgcrypt, gtk3, vala, gnome3
, python3 }:

stdenv.mkDerivation rec {
  name = "gtk-vnc-${version}";
  version = "0.9.0";

  outputs = [ "out" "bin" "man" "dev" ];

  src = fetchurl {
    url = "mirror://gnome/sources/gtk-vnc/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "1dya1wc9vis8h0fv625pii1n70cckf1xjg1m2hndz989d118i6is";
  };

  nativeBuildInputs = [
    python3 pkgconfig intltool libtool gobject-introspection vala
  ];
  buildInputs = [
    gnutls cairo glib libgcrypt cyrus_sasl libpulseaudio gtk3
  ];

  configureFlags = [
    "--with-examples"
  ];

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gtk-vnc";
      versionPolicy = "none";
    };
  };

  meta = with stdenv.lib; {
    description = "A GTK VNC widget";
    homepage = https://wiki.gnome.org/Projects/gtk-vnc;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ raskin offline ];
    platforms = platforms.linux;
  };
}
