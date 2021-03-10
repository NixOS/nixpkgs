{ stdenv
, lib
, fetchurl
, autoreconfHook
, libusb1
, pkg-config
, perl
, python3
, dbus
, polkit
, systemd
, IOKit
}:

stdenv.mkDerivation rec {
  pname = "pcsclite";
  version = "1.9.1";

  outputs = [ "bin" "out" "dev" "doc" "man" ];

  src = fetchurl {
    url = "https://pcsclite.apdu.fr/files/pcsc-lite-${version}.tar.bz2";
    sha256 = "sha256-c8R4m3h2qDOnD0k82iFlXf6FaJ2bfilwHCQyduVeaDo=";
  };

  patches = [ ./no-dropdir-literals.patch ];

  postPatch = ''
    sed -i configure.ac \
      -e "s@polkit_policy_dir=.*@polkit_policy_dir=$bin/share/polkit-1/actions@"
  '';

  configureFlags = [
    "--enable-confdir=/etc"
    # The OS should care on preparing the drivers into this location
    "--enable-usbdropdir=/var/lib/pcsc/drivers"
  ] ++ (if stdenv.isLinux then [
    "--enable-ipcdir=/run/pcscd"
    "--enable-polkit"
    "--with-systemdsystemunitdir=${placeholder "bin"}/lib/systemd/system"
  ] else [
    "--disable-libsystemd"
  ]) ++ lib.optional (stdenv.hostPlatform.isMusl)
      "--disable-libudev";

  postConfigure = ''
    sed -i -re '/^#define *PCSCLITE_HP_DROPDIR */ {
      s/(DROPDIR *)(.*)/\1(getenv("PCSCLITE_HP_DROPDIR") ? : \2)/
    }' config.h
  '';

  postInstall = ''
    # pcsc-spy is a debugging utility and it drags python into the closure
    moveToOutput bin/pcsc-spy "$dev"
  '';

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook pkg-config perl ];

  buildInputs = [ python3 ] ++ lib.optionals stdenv.isLinux [
    dbus
    (if stdenv.hostPlatform.isMusl then libusb1 else systemd)
  ] ++ lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with lib; {
    description = "Middleware to access a smart card using SCard API (PC/SC)";
    homepage = "https://pcsclite.apdu.fr/";
    license = licenses.bsd3;
    platforms = with platforms; unix;
  };
}
