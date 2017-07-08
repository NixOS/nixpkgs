{ stdenv, fetchFromGitHub, autoconf, automake, libtool, pkgconfig, dbus_libs, dbus_glib, libxml2 }:

stdenv.mkDerivation rec {
  name = "thermald-${version}";
  version = "1.6";

  src = fetchFromGitHub {
    owner = "01org";
    repo = "thermal_daemon";
    rev = "v${version}";
    sha256 = "1qzvmzkzdrmwrzfbxb2rz1i39j5zskjxiiv1w9m0xyg08p2wr7h3";
  };

  buildInputs = [ autoconf automake libtool pkgconfig dbus_libs dbus_glib libxml2 ];

  patchPhase = ''sed -e 's/upstartconfdir = \/etc\/init/upstartconfdir = $(out)\/etc\/init/' -i data/Makefile.am'';

  preConfigure = ''
    export PKG_CONFIG_PATH="${dbus_libs.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
    ./autogen.sh
  '';

  configureFlags = [
    "--sysconfdir=$(out)/etc" "--localstatedir=/var"
    "--with-dbus-sys-dir=$(out)/etc/dbus-1/system.d"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    ];

  meta = with stdenv.lib; {
    description = "Thermal Daemon";
    homepage = "https://01.org/linux-thermal-daemon";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ abbradar ];
  };
}
