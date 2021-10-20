{ lib, stdenv
, fetchgit
, autoreconfHook
, pkg-config
, glib
, dbus
, ell
, systemd
, bluez
, mobile-broadband-provider-info
}:

stdenv.mkDerivation rec {
  pname = "ofono";
  version = "1.32";

  outputs = [ "out" "dev" ];

  src = fetchgit {
    url = "git://git.kernel.org/pub/scm/network/ofono/ofono.git";
    rev = version;
    sha256 = "sha256-bJ7Qgau5soPiptrhcMZ8rWxfprRCTeR7OjQ5HZQ9hbc=";
  };

  patches = [
    ./0001-Search-connectors-in-OFONO_PLUGIN_PATH.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    glib
    dbus
    ell
    systemd
    bluez
    mobile-broadband-provider-info
  ];

  configureFlags = [
    "--with-dbusconfdir=${placeholder "out"}/share"
    "--with-systemdunitdir=${placeholder "out"}/lib/systemd/system"
    "--enable-external-ell"
    "--sysconfdir=/etc"
  ];

  installFlags = [
    "sysconfdir=${placeholder "out"}/etc"
  ];

  enableParallelBuilding = true;
  enableParallelChecking = false;

  doCheck = true;

  meta = with lib; {
    description = "Infrastructure for building mobile telephony (GSM/UMTS) applications";
    homepage = "https://01.org/ofono";
    license = licenses.gpl2;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
