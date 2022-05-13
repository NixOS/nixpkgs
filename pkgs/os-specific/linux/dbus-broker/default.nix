{ lib, stdenv, fetchzip, docutils, meson, ninja, pkg-config
, dbus, linuxHeaders, systemd }:

stdenv.mkDerivation rec {
  pname = "dbus-broker";
  version = "30";

  src = fetchzip {
    url = "https://github.com/bus1/dbus-broker/releases/download/v${version}/dbus-broker-${version}.tar.xz";
    sha256 = "1bgn90kprcmx7pr4fc2g9v9vsz73x35c3x0vipirq5gcrcy97pmd";
  };

  nativeBuildInputs = [ docutils meson ninja pkg-config ];

  buildInputs = [ dbus linuxHeaders systemd ];

  mesonFlags = [ "-D=system-console-users=gdm,sddm,lightdm" ];

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
  PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "${placeholder "out"}/lib/systemd/user";
  PKG_CONFIG_SYSTEMD_CATALOGDIR = "${placeholder "out"}/lib/systemd/catalog";

  postInstall = ''
    install -Dm644 $src/README.md $out/share/doc/dbus-broker/README

    sed -i $out/lib/systemd/{system,user}/dbus-broker.service \
      -e 's,^ExecReload.*busctl,ExecReload=${systemd}/bin/busctl,'
  '';

  doCheck = true;

  meta = with lib; {
    description = "Linux D-Bus Message Broker";
    homepage    = "https://github.com/bus1/dbus-broker/wiki";
    license     = licenses.asl20;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
