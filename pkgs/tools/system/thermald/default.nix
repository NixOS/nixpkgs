{ stdenv, fetchurl, unzip, autoconf, automake, libtool, pkgconfig, dbus_libs, dbus_glib, libxml2 }:

stdenv.mkDerivation rec {
  version = "1.3";
  name = "thermald-${version}";
  src = fetchurl {
    url = "https://github.com/01org/thermal_daemon/archive/v${version}.zip";
    sha256 = "0jqxc8vvd4lx4z0kcdisk8lpdf823nysvjcfjxlr5wzla1xysqwc";
  };
  buildInputs = [ unzip autoconf automake libtool pkgconfig dbus_libs dbus_glib libxml2 ];

  patchPhase = ''sed -e 's/upstartconfdir = \/etc\/init/upstartconfdir = $(out)\/etc\/init/' -i data/Makefile.am'';

  preConfigure = ''
                   export PKG_CONFIG_PATH="${dbus_libs}/lib/pkgconfig:$PKG_CONFIG_PATH"
                   ./autogen.sh #--prefix="$out"
                 '';

  configureFlags = [
    "--sysconfdir=$(out)/etc" "--localstatedir=/var"
    "--with-dbus-sys-dir=$(out)/etc/dbus-1/system.d"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    ];

  preInstall = "sysconfdir=$out/etc";


  meta = {
    description = "Thermal Daemon";
    longDescription = ''
         Thermal Daemon
    '';
    homepage = https://01.org/linux-thermal-daemon;
    license = stdenv.lib.licenses.gpl2;
  };
}
