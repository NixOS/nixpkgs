{ stdenv, fetchurl, pkgconfig, udev, dbus_libs, perl, python2
, IOKit ? null }:

stdenv.mkDerivation rec {
  name = "pcsclite-${version}";
  version = "1.8.17";

  src = fetchurl {
    url = "https://alioth.debian.org/frs/download.php/file/4173/pcsc-lite-${version}.tar.bz2";
    sha256 = "0vq2291kvnbg8czlakqahxrdhsvp74fqy3z75lfjlkq2aj36yayp";
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
