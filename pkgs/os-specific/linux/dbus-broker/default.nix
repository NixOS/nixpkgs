{ stdenv, fetchFromGitHub, docutils, meson, ninja, pkgconfig
, dbus, linuxHeaders, systemd }:

stdenv.mkDerivation rec {
  pname = "dbus-broker";
  version = "22";

  src = fetchFromGitHub {
    owner  = "bus1";
    repo   = "dbus-broker";
    rev    = "v${version}";
    sha256 = "0vxr73afix5wjxy8g4cckwhl242rrlazm52673iwmdyfz5nskj2x";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ docutils meson ninja pkgconfig ];

  buildInputs = [ dbus linuxHeaders systemd ];

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
  PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "${placeholder "out"}/lib/systemd/user";
  PKG_CONFIG_SYSTEMD_CATALOGDIR = "${placeholder "out"}/lib/systemd/catalog";

  postInstall = ''
    install -Dm644 $src/README.md $out/share/doc/dbus-broker/README

    sed -i $out/lib/systemd/{system,user}/dbus-broker.service \
      -e 's,^ExecReload.*busctl,ExecReload=${systemd}/bin/busctl,'
  '';

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Linux D-Bus Message Broker";
    homepage    = https://github.com/bus1/dbus-broker/wiki;
    license     = licenses.asl20;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
