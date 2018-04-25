{ stdenv, fetchgit, fetchFromGitHub, docutils, meson, ninja, pkgconfig
, dbus, glib, linuxHeaders, systemd }:

stdenv.mkDerivation rec {
  name = "dbus-broker-${version}";
  version = "11";

  src = fetchFromGitHub {
    owner           = "bus1";
    repo            = "dbus-broker";
    rev             = "v${version}";
    sha256          = "19sszb6ac7md494i996ixqmz9b3gim8rrv2nbrmlgjd59gk6hf7b";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ docutils meson ninja pkgconfig ];

  buildInputs = [ dbus glib linuxHeaders systemd ];

  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMUNITDIR = "lib/systemd/system";
  PKG_CONFIG_SYSTEMD_SYSTEMDUSERUNITDIR = "lib/systemd/user";

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
