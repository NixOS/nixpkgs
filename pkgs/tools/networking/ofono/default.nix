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
<<<<<<< HEAD
  version = "2.1";
=======
  version = "2.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  outputs = [ "out" "dev" ];

  src = fetchgit {
    url = "https://git.kernel.org/pub/scm/network/ofono/ofono.git";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-GxQfh/ps5oM9G6B1EVgnjo8LqHD1hMqdnju1PCQq3kA=";
=======
    sha256 = "sha256-T8rfReruvHGQCN9IDGIrFCoNjFKKMnUGPKzxo2HTZFQ=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ jtojnar ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = platforms.linux;
  };
}
