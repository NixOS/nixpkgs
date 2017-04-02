{ stdenv, fetchurl, pkgconfig, udev, dbus_libs, perl, python2
, IOKit ? null }:

stdenv.mkDerivation rec {
  name = "pcsclite-${version}";
  version = "1.8.20";

  src = fetchurl {
    # This URL changes in unpredictable ways, so it is not sensicle
    # to put a version variable in there.
    url = "https://alioth.debian.org/frs/download.php/file/4203/pcsc-lite-1.8.20.tar.bz2";
    sha256 = "1ckb0jf4n585a4j26va3jm2nrv3c1y38974514f8qy3c04a02zgc";
  };

  patches = [ ./no-dropdir-literals.patch ];

  configureFlags = [
    # The OS should care on preparing the drivers into this location
    "--enable-usbdropdir=/var/lib/pcsc/drivers"
    "--enable-confdir=/etc"
    "--enable-ipcdir=/run/pcscd"
  ] ++ stdenv.lib.optional stdenv.isLinux
         "--with-systemdsystemunitdir=\${out}/etc/systemd/system";

  postConfigure = ''
    sed -i -re '/^#define *PCSCLITE_HP_DROPDIR */ {
      s/(DROPDIR *)(.*)/\1(getenv("PCSCLITE_HP_DROPDIR") ? : \2)/
    }' config.h
  '';

  nativeBuildInputs = [ pkgconfig perl python2 ];
  buildInputs = stdenv.lib.optionals stdenv.isLinux [ udev dbus_libs ]
             ++ stdenv.lib.optionals stdenv.isDarwin [ IOKit ];

  meta = with stdenv.lib; {
    description = "Middleware to access a smart card using SCard API (PC/SC)";
    homepage = http://pcsclite.alioth.debian.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ viric wkennington ];
    platforms = with platforms; unix;
  };
}
