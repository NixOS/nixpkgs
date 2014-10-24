{ stdenv, fetchurl, pkgconfig, libusb, libyubikey, json_c }:

stdenv.mkDerivation rec {
  name = "yubikey-personalization-${version}";
  version = "1.16.0";

  src = fetchurl {
    url = "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-${version}.tar.gz";
    sha256 = "1zspbb10k9x9mjv8hadmwwgzjlign372al3zshypj9ri55ky0xs3";
  };

  buildInputs = [ pkgconfig libusb libyubikey json_c ];

  configureFlags = [
    "--with-backend=libusb-1.0"
  ];

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/yubikey-personalization;
    description = "a library and command line tool to personalize YubiKeys";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
