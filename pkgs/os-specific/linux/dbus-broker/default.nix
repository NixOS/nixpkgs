{ stdenv, fetchgit, fetchFromGitHub, docutils, meson, ninja, pkgconfig
, dbus, glib, systemd }:

stdenv.mkDerivation rec {
  name = "dbus-broker-${version}";
  version = "8";

  src = fetchFromGitHub {
    owner           = "bus1";
    repo            = "dbus-broker";
    rev             = "v${version}";
    sha256          = "07k8y6pcx58dfd0vvxcbz352v4apajs5lf0chv6fdp7xf7wbbcwb";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ docutils meson ninja pkgconfig ];

  buildInputs = [ dbus glib systemd ];

  enableParallelBuilding = true;

  prePatch = ''
    substituteInPlace meson.build \
      --replace "dep_systemd.get_pkgconfig_variable('systemdsystemunitdir')" "'$out/lib/systemd/system'" \
      --replace "dep_systemd.get_pkgconfig_variable('systemduserunitdir')"   "'$out/lib/systemd/user'"
  '';

  postInstall = ''
    install -Dm644 ../README $out/share/doc/dbus-broker/README
  '';

  checkPhase = "ninja test";

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Linux D-Bus Message Broker";
    homepage    = https://github.com/bus1/dbus-broker/wiki;
    license     = licenses.asl20;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
