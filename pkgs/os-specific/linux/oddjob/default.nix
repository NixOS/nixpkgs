{
  autoreconfHook,
  dbus,
  fetchpatch,
  fetchurl,
  lib,
  libxml2,
  nixosTests,
  pam,
  pkg-config,
  stdenv,
  systemd,
}:

stdenv.mkDerivation rec {
  pname = "oddjob";
  version = "0.34.7";

  src = fetchurl {
    url = "https://pagure.io/oddjob/archive/${pname}-${version}/oddjob-${pname}-${version}.tar.gz";
    hash = "sha256-SUOsMH55HtEsk5rX0CXK0apDObTj738FGOaL5xZRnIM=";
  };

  patches = [
    # Define SystemD service location using `with-systemdsystemunitdir` configure flag
    (fetchpatch {
      url = "https://pagure.io/oddjob/c/f63287a35107385dcb6e04a4c742077c9d1eab86.patch";
      hash = "sha256-2mmw4pJhrIk4/47FM8zKH0dTQJWnntHPNmq8VAUWqJI=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    dbus
    libxml2
    pam
    systemd
  ];

  configureFlags = [
    "--prefix=${placeholder "out"}"
    "--sysconfdir=${placeholder "out"}/etc"
    "--with-selinux-acls=no"
    "--with-selinux-labels=no"
    "--with-systemdsystemunitdir=${placeholder "out"}/lib/systemd/system"
  ];

  postConfigure = ''
    substituteInPlace src/oddjobd.c \
      --replace "globals.selinux_enabled" "FALSE"
  '';

  # Requires a dbus-daemon environment
  doCheck = false;

  passthru.tests = {
    inherit (nixosTests) oddjobd;
  };

  meta = {
    changelog = "https://pagure.io/oddjob/blob/oddjob-${version}/f/ChangeLog";
    description = "Odd Job Daemon";
    homepage = "https://pagure.io/oddjob";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ SohamG ];
    platforms = lib.platforms.linux;
  };
}
