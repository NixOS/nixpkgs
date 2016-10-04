{ stdenv, fetchurl, gobjectIntrospection
, gnutls, cairo, libtool, glib, pkgconfig, libtasn1
, libffi, cyrus_sasl, intltool, perl, perlPackages, libpulseaudio
, kbproto, libX11, libXext, xextproto, libgcrypt, gtk3, vala_0_32
, libogg, libgpgerror, pythonPackages }:

let
  inherit (pythonPackages) pygobject3 python;
in stdenv.mkDerivation rec {
  name = "gtk-vnc-${version}";
  version = "0.6.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk-vnc/0.6/${name}.tar.xz";
    sha256 = "9559348805e64d130dae569fee466930175dbe150d2649bb868b5c095f130433";
  };

  buildInputs = [
    python gnutls cairo libtool pkgconfig glib libffi libgcrypt
    intltool cyrus_sasl libpulseaudio perl perlPackages.TextCSV
    gobjectIntrospection libogg libgpgerror
    gtk3 vala_0_32 pygobject3 ];

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
