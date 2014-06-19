{ stdenv, fetchurl, gobjectIntrospection
, python, gtk, pygtk, gnutls, cairo, libtool, glib, pkgconfig, libtasn1
, libffi, cyrus_sasl, intltool, perl, perlPackages, firefoxPkgs, pulseaudio
, kbproto, libX11, libXext, xextproto, pygobject, libgcrypt, gtk3, vala
, pygobject3, libogg, enableGTK3 ? false }:

stdenv.mkDerivation rec {
  name = "gtk-vnc-${version}";
  version = "0.5.3";

  src = fetchurl {
    url = "mirror://gnome/sources/gtk-vnc/0.5/${name}.tar.xz";
    sha256 = "1bww2ihxb3zzvifdrcsy1lifr664pvikq17hmr1hsm8fyk4ad46l";
  };

  buildInputs = [
    python gnutls cairo libtool pkgconfig glib libffi libgcrypt
    intltool cyrus_sasl pulseaudio perl perlPackages.TextCSV
    gobjectIntrospection libogg
  ] ++ (if enableGTK3 then [ gtk3 vala pygobject3 ] else [ gtk pygtk pygobject ]);

  NIX_CFLAGS_COMPILE = "-fstack-protector-all";
  configureFlags = [
    "--with-python"
    "--with-examples"
    (if enableGTK3 then "--with-gtk=3.0" else "--with-gtk=2.0")
  ];

  makeFlags = stdenv.lib.optionalString (!enableGTK3)
    "CODEGENDIR=${pygobject}/share/pygobject/2.0/codegen/ DEFSDIR=${pygtk}/share/pygtk/2.0/defs/";

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
