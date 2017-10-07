{ stdenv, fetchurl, gobjectIntrospection
, gnutls, cairo, libtool, glib, pkgconfig, libtasn1
, libffi, cyrus_sasl, intltool, perl, perlPackages, libpulseaudio
, kbproto, libX11, libXext, xextproto, libgcrypt, gtk3, vala_0_32
, libogg, libgpgerror, pythonPackages }:

let
  inherit (pythonPackages) pygobject3 python;
in stdenv.mkDerivation rec {
  name = "gtk-vnc-${version}";
  version = "0.7.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk-vnc/${stdenv.lib.strings.substring 0 3 version}/${name}.tar.xz";
    sha256 = "0gj8dpy3sj4dp810gy67spzh5f0jd8aqg69clcwqjcskj1yawbiw";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    python gnutls cairo libtool glib libffi libgcrypt
    intltool cyrus_sasl libpulseaudio perl perlPackages.TextCSV
    gobjectIntrospection libogg libgpgerror
    gtk3 vala_0_32 pygobject3
  ];

  NIX_CFLAGS_COMPILE = "-fstack-protector-all";
  configureFlags = [
    "--with-python"
    "--with-examples"
  ];

  # Fix broken .la files
  preFixup = ''
    sed 's,-lgpg-error,-L${libgpgerror.out}/lib -lgpg-error,' -i $out/lib/*.la
  '';

  meta = with stdenv.lib; {
    description = "A GTK VNC widget";
    maintainers = with maintainers; [ raskin offline ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://ftp.gnome.org/pub/GNOME/sources/gtk-vnc";
    };
  };
}
