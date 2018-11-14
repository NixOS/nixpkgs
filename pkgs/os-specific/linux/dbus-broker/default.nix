{ stdenv, fetchFromGitHub, docutils, meson, ninja, pkgconfig
, dbus, glib, linuxHeaders, systemd }:

stdenv.mkDerivation rec {
  name = "dbus-broker-${version}";
  version = "13";

  src = fetchFromGitHub {
    owner  = "bus1";
    repo   = "dbus-broker";
    rev    = "v${version}";
    sha256 = "1yjkxpnl54pky6ha3y8dsds57lnk10lmriyzpzy0ha2npng2614x";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ docutils meson ninja pkgconfig ];

  buildInputs = [ dbus glib linuxHeaders systemd ];

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
  PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "${placeholder "out"}/lib/systemd/user";

  postInstall = ''
    install -Dm644 ../README $out/share/doc/dbus-broker/README

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
