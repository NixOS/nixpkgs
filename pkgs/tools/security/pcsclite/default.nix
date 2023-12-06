{ stdenv
, lib
, fetchurl
, autoreconfHook
, autoconf-archive
, flex
, pkg-config
, perl
, python3
, dbus
, polkit
, systemdLibs
, IOKit
, gitUpdater
, pname ? "pcsclite"
, polkitSupport ? false
}:

stdenv.mkDerivation rec {
  inherit pname;
  version = "2.0.1";

  outputs = [ "bin" "out" "dev" "doc" "man" ];

  src = fetchurl {
    url = "https://pcsclite.apdu.fr/files/pcsc-lite-${version}.tar.bz2";
    hash = "sha256-XtyvXUVEQDvatu4rXWwCxvl+pk7r8IJbjQ+mG6QX2to=";
  };

  configureFlags = [
    "--enable-confdir=/etc"
    # The OS should care on preparing the drivers into this location
    "--enable-usbdropdir=/var/lib/pcsc/drivers"
    (lib.enableFeature stdenv.isLinux "libsystemd")
    (lib.enableFeature polkitSupport "polkit")
  ] ++ lib.optionals stdenv.isLinux [
    "--enable-ipcdir=/run/pcscd"
    "--with-systemdsystemunitdir=${placeholder "bin"}/lib/systemd/system"
  ];

  makeFlags = [
    "POLICY_DIR=$(out)/share/polkit-1/actions"
  ];

  postInstall = ''
    # pcsc-spy is a debugging utility and it drags python into the closure
    moveToOutput bin/pcsc-spy "$dev"
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    autoconf-archive
    flex
    pkg-config
    perl
  ];

  buildInputs = [ python3 ]
    ++ lib.optionals stdenv.isLinux [ systemdLibs ]
    ++ lib.optionals stdenv.isDarwin [ IOKit ]
    ++ lib.optionals polkitSupport [ dbus polkit ];

  passthru.updateScript = gitUpdater {
    url = "https://salsa.debian.org/rousseau/PCSC.git";
  };

  meta = with lib; {
    description = "Middleware to access a smart card using SCard API (PC/SC)";
    homepage = "https://pcsclite.apdu.fr/";
    license = licenses.bsd3;
    maintainers = [ maintainers.anthonyroussel ];
    platforms = with platforms; unix;
  };
}
