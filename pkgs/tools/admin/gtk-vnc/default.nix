{ stdenv, fetchurl, gobjectIntrospection
, gnutls, cairo, libtool, glib, pkgconfig, libtasn1
, libffi, cyrus_sasl, intltool, perl, perlPackages, libpulseaudio
, kbproto, libX11, libXext, xextproto, libgcrypt, gtk3, vala_0_23
, libogg, libgpgerror, pythonPackages }:

let
  inherit (pythonPackages) pygobject3 python;
in stdenv.mkDerivation rec {
  name = "gtk-vnc-${version}";
  version = "0.5.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk-vnc/0.5/${name}.tar.xz";
    sha256 = "1bww2ihxb3zzvifdrcsy1lifr664pvikq17hmr1hsm8fyk4ad46l";
  };

  buildInputs = [
    python gnutls cairo libtool pkgconfig glib libffi libgcrypt
    intltool cyrus_sasl libpulseaudio perl perlPackages.TextCSV
    gobjectIntrospection libogg libgpgerror
    gtk3 vala_0_23 pygobject3 ];

  NIX_CFLAGS_COMPILE = "-fstack-protector-all";
  configureFlags = [
    "--with-python"
    "--with-examples"
    "--with-gtk=3.0"
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
