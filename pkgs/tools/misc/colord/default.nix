{ stdenv, fetchurl, bash-completion
, glib, polkit, pkgconfig, gettext, gusb, lcms2, sqlite, systemd, dbus
, gobjectIntrospection, argyllcms, meson, ninja, libxml2, vala_0_38
, libgudev, sane-backends }:

stdenv.mkDerivation rec {
  name = "colord-1.4.1";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/colord/releases/${name}.tar.xz";
    sha256 = "0m854clp8szvq38z16jpazzlqfb3lb3icxcfnsisfrc25748y1ib";
  };

  enableParallelBuilding = true;

  mesonFlags = [
    "-Denable-sane=true"
    "-Denable-vala=true"
    "--localstatedir=/var"
    "-Denable-bash-completion=true"
    # TODO: man page cannot be build with docbook2x
    "-Denable-man=false"
    "-Denable-docs=false"
  ];

  patches = [
    ./fix-build-paths.patch
  ];

  nativeBuildInputs = [ meson pkgconfig vala_0_38 ninja gettext libxml2 gobjectIntrospection ];

  buildInputs = [ glib polkit gusb lcms2 sqlite systemd dbus
                  bash-completion argyllcms libgudev sane-backends ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  meta = {
    description = "System service to manage, install and generate color profiles to accurately color manage input and output devices";
    homepage = https://www.freedesktop.org/software/colord/;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
