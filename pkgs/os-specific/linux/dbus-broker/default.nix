{ stdenv, fetchFromGitHub, docutils, meson, ninja, pkgconfig
, dbus, linuxHeaders, systemd }:

stdenv.mkDerivation rec {
  name = "dbus-broker-${version}";
  version = "17";

  src = fetchFromGitHub {
    owner  = "bus1";
    repo   = "dbus-broker";
    rev    = "v${version}";
    sha256 = "19q5f1c658jdxvr2k2rb2xsnspybqjii4rifnlkzi1qzh0r152md";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ docutils meson ninja pkgconfig ];

  buildInputs = [ dbus linuxHeaders systemd ];

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "${placeholder "out"}/lib/systemd/system";
  PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "${placeholder "out"}/lib/systemd/user";

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
