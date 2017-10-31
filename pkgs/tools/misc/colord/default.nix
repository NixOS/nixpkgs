{ stdenv, fetchurl, bash-completion
, glib, polkit, pkgconfig, intltool, gusb, libusb1, lcms2, sqlite, systemd, dbus
, gtk_doc, gobjectIntrospection, argyllcms, autoreconfHook
, libgudev, sane-backends }:

stdenv.mkDerivation rec {
  name = "colord-1.2.12";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/colord/releases/${name}.tar.xz";
    sha256 = "0flcsr148xshjbff030pgyk9ar25an901m9q1pjgjdvaq5j1h96m";
  };

  enableParallelBuilding = true;

  # Version mismatch requires intltoolize to overwrite
  # with newer version.
  preConfigure = ''
    intltoolize --force
  '';

  configureFlags = [
    "--enable-sane"
    "--with-udevrulesdir=$(out)/lib/udev/rules.d"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--localstatedir=/var"
    "--disable-bash-completion"
  ];


  # don't touch /var at install time, colord creates what it needs at runtime
  postPatch = ''
    sed -e "s|if test -w .*;|if false;|" -i src/Makefile.{am,in}
  '';

  nativeBuildInputs = [ autoreconfHook intltool pkgconfig ];

  buildInputs = [ glib polkit gusb libusb1 lcms2 sqlite systemd dbus gobjectIntrospection
                  bash-completion argyllcms libgudev sane-backends ];

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
