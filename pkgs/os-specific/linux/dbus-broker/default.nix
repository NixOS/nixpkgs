{ stdenv, fetchgit, fetchFromGitHub, meson, ninja, pkgconfig
, dbus, glib, systemd }:

stdenv.mkDerivation rec {
  name = "dbus-broker-${version}";
  version = "3";

  src = fetchFromGitHub {
    owner           = "bus1";
    repo            = "dbus-broker";
    rev             = "v${version}";
    sha256          = "1f2vw5b2cbdgd3g7vnzwr9lsw9v4xc5nc0nf9xc3qb5xqzsq7v7i";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ meson ninja pkgconfig ];
  buildInputs = [ dbus glib systemd ];

  prePatch = ''
    substituteInPlace meson.build \
      --replace "dep_systemd.get_pkgconfig_variable('systemdsystemunitdir')" "'$out/lib/systemd/system'" \
      --replace "dep_systemd.get_pkgconfig_variable('systemduserunitdir')"   "'$out/lib/systemd/user'"
  '';

  preConfigure = ''
    mkdir build
    meson --prefix "$out" --buildtype=release build/
  '';

  buildPhase = "ninja -C build";

  installPhase = ''
    ninja -C build install
    install -Dm644 README $out/share/doc/dbus-broker/README
  '';

  checkPhase = "ninja -C build test";

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Linux D-Bus Message Broker";
    homepage    = https://github.com/bus1/dbus-broker/wiki;
    license     = licenses.asl20;
    platforms   = platforms.linux;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
