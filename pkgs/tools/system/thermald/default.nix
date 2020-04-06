{ stdenv, fetchFromGitHub, autoconf, automake, libtool
, pkgconfig, dbus, dbus-glib, libxml2 }:

stdenv.mkDerivation rec {
  pname = "thermald";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "01org";
    repo = "thermal_daemon";
    rev = "v${version}";
    sha256 = "0iagc3jqpnh6q2fa1gx4wx6r8qg0556j60xr159zqg95djr4dv99";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf automake libtool dbus dbus-glib libxml2 ];

  patchPhase = ''sed -e 's/upstartconfdir = \/etc\/init/upstartconfdir = $(out)\/etc\/init/' -i data/Makefile.am'';

  preConfigure = ''
    export PKG_CONFIG_PATH="${dbus.dev}/lib/pkgconfig:$PKG_CONFIG_PATH"
    ./autogen.sh
  '';

  configureFlags = [
    "--sysconfdir=${placeholder "out"}/etc"
    "--localstatedir=/var"
    "--with-dbus-sys-dir=${placeholder "out"}/share/dbus-1/system.d"
    "--with-systemdsystemunitdir=${placeholder "out"}/etc/systemd/system"
    ];

  meta = with stdenv.lib; {
    description = "Thermal Daemon";
    homepage = https://01.org/linux-thermal-daemon;
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
