{ stdenv, fetchurl, intltool, perl, gettext, libusb, pkgconfig, bluez
, readline, pcsclite, libical, gtk, glib, libXpm }:

stdenv.mkDerivation rec {
  name = "gnokii-${version}";
  version = "0.6.31";

  src = fetchurl {
    sha256 = "0sjjhm40662bj6j0jh3sd25b8nww54nirpwamz618rg6pb5hjwm8";
    url = "http://www.gnokii.org/download/gnokii/${name}.tar.gz";
  };

  buildInputs = [
    perl intltool gettext libusb
    glib gtk pkgconfig bluez readline
    libXpm pcsclite libical
  ];

  meta = {
    description = "Cellphone tool";
    homepage = http://www.gnokii.org;
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
  };
}
