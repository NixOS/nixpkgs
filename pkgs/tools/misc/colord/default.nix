{ stdenv, fetchurl, fetchgit, bashCompletion
, glib, polkit, pkgconfig, intltool, gusb, libusb1, lcms2, sqlite, systemd, dbus
, automake, autoconf, libtool, gtk_doc, which, gobjectIntrospection }:

stdenv.mkDerivation rec {
  name = "colord-1.1.7";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/colord/releases/${name}.tar.xz";
    sha256 = "295395526ee0be30917ae9c352e68bfeb20c7fc266a605725bef969f20547f44";
  };

  enableParallelBuilding = true;

  configureFlags = [
    "--with-udevrulesdir=$out/lib/udev/rules.d"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--disable-bash-completion"
  ];

  buildInputs = [ glib polkit pkgconfig intltool gusb libusb1 lcms2 sqlite systemd dbus gobjectIntrospection
                  bashCompletion ];

  postInstall = ''
    rm -fr $out/var/lib/colord
    mkdir -p $out/etc/bash_completion.d
    cp -v data/colormgr $out/etc/bash_completion.d
  '';

  meta = {
    description = "system service that makes it easy to manage, install and generate color profiles to accurately color manage input and output devices";
    homepage = http://www.freedesktop.org/software/colord/intro.html;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
