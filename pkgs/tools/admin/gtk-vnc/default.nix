{ stdenv, fetchurl
, python, gtk, pygtk, gnutls, cairo, libtool, glib, pkgconfig, libtasn1
, libffi, cyrus_sasl, intltool, perl, perlPackages, firefoxPkgs, pulseaudio
, kbproto, libX11, libXext, xextproto, pygobject, libgcrypt }:


stdenv.mkDerivation rec {
  name = "gtk-vnc-${version}";
  version = "0.5.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk-vnc/0.5/${name}.tar.xz";
    sha256 = "1bww2ihxb3zzvifdrcsy1lifr664pvikq17hmr1hsm8fyk4ad46l";
  };

  buildInputs = [
    python gtk pygtk gnutls cairo libtool pkgconfig glib libffi libgcrypt
    intltool cyrus_sasl pulseaudio pygobject perl perlPackages.TextCSV
  ];

  NIX_CFLAGS_COMPILE = "-fstack-protector-all";
  configureFlags = [
    "--with-python"
    "--with-examples"
  ];

  makeFlags = "CODEGENDIR=${pygobject}/share/pygobject/2.0/codegen/ DEFSDIR=${pygtk}/share/pygtk/2.0/defs/";

  meta = with stdenv.lib; {
    description = "A GTK VNC widget";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.lgpl21;
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://ftp.gnome.org/pub/GNOME/sources/gtk-vnc";
    };
  };
}
