{ stdenv, fetchurl, intltool, perl, gettext, libusb-compat-0_1, pkgconfig, bluez
, readline, pcsclite, libical, gtk2, glib, libXpm }:

stdenv.mkDerivation rec {
  pname = "gnokii";
  version = "0.6.31";

  src = fetchurl {
    sha256 = "0sjjhm40662bj6j0jh3sd25b8nww54nirpwamz618rg6pb5hjwm8";
    url = "https://www.gnokii.org/download/gnokii/${pname}-${version}.tar.gz";
  };

  buildInputs = [
    perl intltool gettext libusb-compat-0_1
    glib gtk2 pkgconfig bluez readline
    libXpm pcsclite libical
  ];

  meta = {
    description = "Cellphone tool";
    homepage = "http://www.gnokii.org";
    maintainers = [ stdenv.lib.maintainers.raskin ];
    platforms = stdenv.lib.platforms.linux;
    broken = true; # 2018-04-10
  };
}
