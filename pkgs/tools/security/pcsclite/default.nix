{ lib, stdenv, fetchurl, pkg-config, udev, dbus, perl, python3
, IOKit ? null }:

stdenv.mkDerivation rec {
  pname = "pcsclite";
  version = "1.9.1";

  outputs = [ "bin" "out" "dev" "doc" "man" ];

  src = fetchurl {
    url = "https://pcsclite.apdu.fr/files/pcsc-lite-${version}.tar.bz2";
    sha256 = "sha256-c8R4m3h2qDOnD0k82iFlXf6FaJ2bfilwHCQyduVeaDo=";
  };

  patches = [ ./no-dropdir-literals.patch ];

  configureFlags = [
    # The OS should care on preparing the drivers into this location
    "--enable-usbdropdir=/var/lib/pcsc/drivers"
    "--enable-confdir=/etc"
  ] ++ lib.optional stdenv.isLinux
         "--with-systemdsystemunitdir=\${out}/etc/systemd/system"
    ++ lib.optional (!stdenv.isLinux)
         "--disable-libsystemd";

  postConfigure = ''
    sed -i -re '/^#define *PCSCLITE_HP_DROPDIR */ {
      s/(DROPDIR *)(.*)/\1(getenv("PCSCLITE_HP_DROPDIR") ? : \2)/
    }' config.h
  '';

  postInstall = ''
    # pcsc-spy is a debugging utility and it drags python into the closure
    moveToOutput bin/pcsc-spy "$dev"
  '';

  nativeBuildInputs = [ pkg-config perl ];
  buildInputs = [ python3 ] ++ lib.optionals stdenv.isLinux [ udev dbus ]
             ++ lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with lib; {
    description = "Middleware to access a smart card using SCard API (PC/SC)";
    homepage = "https://pcsclite.apdu.fr/";
    license = licenses.bsd3;
    platforms = with platforms; unix;
  };
}
