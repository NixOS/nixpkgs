{ stdenv, fetchFromGitHub, autoconf, automake, libtool
, pkgconfig, dbus, dbus-glib, libxml2, autoconf-archive }:

stdenv.mkDerivation rec {
  pname = "thermald";
  version = "2.1";

  src = fetchFromGitHub {
    owner = "intel";
    repo = "thermal_daemon";
    rev = "v${version}";
    sha256 = "1k8svy03k57ld6p5d29i0ccrd1gics6kbyx1bkfmw9fh1bbljyf7";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ autoconf automake libtool dbus dbus-glib libxml2 autoconf-archive ];

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

  postInstall = ''
    cp ./data/thermal-conf.xml $out/etc/thermald/
  '';

  meta = with stdenv.lib; {
    description = "Thermal Daemon";
    homepage = "https://01.org/linux-thermal-daemon";
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" "i686-linux" ];
    maintainers = with maintainers; [ abbradar ];
  };
}
