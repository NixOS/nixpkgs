{ stdenv, fetchurl, pkgconfig, udev, dbus, perl, python2
, IOKit ? null }:

stdenv.mkDerivation rec {
  name = "pcsclite-${version}";
  version = "1.8.24";

  outputs = [ "bin" "out" "dev" "doc" "man" ];

  src = fetchurl {
    url = "https://pcsclite.apdu.fr/files/pcsc-lite-${version}.tar.bz2";
    sha256 = "0s3mv6csbi9303vvis0hilm71xsmi6cqkbh2kiipdisydbx6865q";
  };

  patches = [ ./no-dropdir-literals.patch ];

  configureFlags = [
    # The OS should care on preparing the drivers into this location
    "--enable-usbdropdir=/var/lib/pcsc/drivers"
    "--enable-confdir=/etc"
    "--enable-ipcdir=/run/pcscd"
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

  nativeBuildInputs = [ pkgconfig perl python2 ];
  buildInputs = stdenv.lib.optionals stdenv.isLinux [ udev dbus ]
             ++ stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with stdenv.lib; {
    description = "Middleware to access a smart card using SCard API (PC/SC)";
    homepage = https://pcsclite.apdu.fr/;
    license = licenses.bsd3;
    platforms = with platforms; unix;
  };
}
