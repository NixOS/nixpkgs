{ stdenv, fetchurl, pkgconfig, udev, dbus, perl, python3
, IOKit ? null }:

stdenv.mkDerivation rec {
  pname = "pcsclite";
  version = "1.9.0";

  outputs = [ "bin" "out" "dev" "doc" "man" ];

  src = fetchurl {
    url = "https://pcsclite.apdu.fr/files/pcsc-lite-${version}.tar.bz2";
    sha256 = "1y9f9zipnrmgiw0mxrvcgky8vfrcmg6zh40gbln5a93i2c1x8j01";
  };

  patches = [ ./no-dropdir-literals.patch ];

  configureFlags = [
    # The OS should care on preparing the drivers into this location
    "--enable-usbdropdir=/var/lib/pcsc/drivers"
    "--enable-confdir=/etc"
  ] ++ stdenv.lib.optional stdenv.isLinux
         "--with-systemdsystemunitdir=\${out}/etc/systemd/system"
    ++ stdenv.lib.optional (!stdenv.isLinux)
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

  nativeBuildInputs = [ pkgconfig perl ];
  buildInputs = [ python3 ] ++ stdenv.lib.optionals stdenv.isLinux [ udev dbus ]
             ++ stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with stdenv.lib; {
    description = "Middleware to access a smart card using SCard API (PC/SC)";
    homepage = "https://pcsclite.apdu.fr/";
    license = licenses.bsd3;
    platforms = with platforms; unix;
  };
}
