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
  version = "2.0";

  outputs = [ "out" "dev" ];

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/network/ofono/ofono.git";
    rev = version;
    sha256 = "sha256-T8rfReruvHGQCN9IDGIrFCoNjFKKMnUGPKzxo2HTZFQ=";
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
    homepage = "https://git.kernel.org/pub/scm/network/ofono/ofono.git";
    changelog = "https://git.kernel.org/pub/scm/network/ofono/ofono.git/plain/ChangeLog?h=${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ jtojnar ];
    platforms = platforms.linux;
  };
}
