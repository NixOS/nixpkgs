{ lib, stdenv
, fetchzip
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
  version = "2.3";

  outputs = [ "out" "dev" ];

  src = fetchzip {
    url = "https://git.kernel.org/pub/scm/network/ofono/ofono.git/snapshot/ofono-${version}.tar.gz";
    sha256 = "sha256-rX3ngXoW7YISyytpRPLX/lGmQa5LPtFxeA2XdtU1gV0=";
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
    maintainers = with maintainers; [ ];
    platforms = platforms.linux;
    mainProgram = "ofonod";
  };
}
