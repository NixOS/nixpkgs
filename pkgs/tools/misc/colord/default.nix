{ stdenv, fetchzip, fetchgit, bashCompletion
, glib, polkit, pkgconfig, intltool, gusb, libusb1, lcms2, sqlite, systemd, dbus
, automake, autoconf, libtool, gtk_doc, which, gobjectIntrospection, argyllcms
, libgudev, sane-backends }:

stdenv.mkDerivation rec {
  name = "colord-1.2.12";

  src = fetchzip {
    url = "http://www.freedesktop.org/software/colord/releases/${name}.tar.xz";
    sha256 = "0rvvbpxd5x479v4p6pck317mlf3j29s154i1n8hlx8n4znhwrb0k";
  };

  enableParallelBuilding = true;

  configureFlags = [
    "--enable-sane"
    "--with-udevrulesdir=$(out)/lib/udev/rules.d"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--localstatedir=/var"
    "--disable-bash-completion"
  ];

  # don't touch /var at install time, colord creates what it needs at runtime
  postPatch = ''
    sed -i -e "s|if test -w .*;|if false;|" src/Makefile.in
    sed -i -e "s|if test -w .*;|if false;|" src/Makefile.am
  '';

  buildInputs = [ glib polkit pkgconfig intltool gusb libusb1 lcms2 sqlite systemd dbus gobjectIntrospection
                  bashCompletion argyllcms automake autoconf libgudev sane-backends ];

  postInstall = ''
    mkdir -p $out/etc/bash_completion.d
    cp -v data/colormgr $out/etc/bash_completion.d
  '';

  meta = {
    description = "System service to manage, install and generate color profiles to accurately color manage input and output devices";
    homepage = http://www.freedesktop.org/software/colord/intro.html;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
