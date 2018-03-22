{ stdenv, fetchurl, bash-completion
, glib, polkit, pkgconfig, gettext, gusb, lcms2, sqlite, systemd, dbus
, gobjectIntrospection, argyllcms, meson, ninja, libxml2, vala_0_40
, libgudev, sane-backends, udev, gnome3, makeWrapper }:

stdenv.mkDerivation rec {
  name = "colord-1.4.2";

  src = fetchurl {
    url = "http://www.freedesktop.org/software/colord/releases/${name}.tar.xz";
    sha256 = "19zc9gldz469jshl16av7na459kwr5nhvs2pz98xm5lw582xaw2c";
  };

  mesonFlags = [
    "-Denable-sane=true"
    "-Denable-vala=true"
    "--localstatedir=/var"
    "-Denable-bash-completion=true"
    # TODO: man page cannot be build with docbook2x
    "-Denable-man=false"
    "-Denable-docs=false"
  ];

  nativeBuildInputs = [ meson pkgconfig vala_0_40 ninja gettext libxml2 gobjectIntrospection makeWrapper ];

  buildInputs = [ glib polkit gusb lcms2 sqlite systemd dbus bash-completion argyllcms libgudev sane-backends ];

  postInstall = ''
    glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
  PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "${placeholder "out"}/lib/systemd/user";
  PKG_CONFIG_SYSTEMD_TMPFILESDIR = "${placeholder "out"}/lib/tmpfiles.d";
  PKG_CONFIG_BASH_COMPLETION_COMPLETIONSDIR= "${placeholder "out"}/share/bash-completion/completions";
  PKG_CONFIG_UDEV_UDEVDIR = "${placeholder "out"}/lib/udev";

  postFixup = ''
    wrapProgram "$out/libexec/colord-session" \
      --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH:$out/share" \
      --prefix GIO_EXTRA_MODULES : "${stdenv.lib.getLib gnome3.dconf}/lib/gio/modules"
  '';

  meta = {
    description = "System service to manage, install and generate color profiles to accurately color manage input and output devices";
    homepage = https://www.freedesktop.org/software/colord/;
    license = stdenv.lib.licenses.lgpl2Plus;
    maintainers = [stdenv.lib.maintainers.marcweber];
    platforms = stdenv.lib.platforms.linux;
  };
}
