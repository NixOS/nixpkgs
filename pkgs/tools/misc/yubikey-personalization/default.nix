{ stdenv, fetchurl, pkgconfig, libusb, libyubikey, json_c }:

stdenv.mkDerivation rec {
  name = "yubikey-personalization-${version}";
  version = "1.18.0";

  src = fetchurl {
    url = "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-${version}.tar.gz";
    sha256 = "1bc2z6y2x7bbqn7ink2dg3wrgqzlcq2zxxg0cdcxy6jm7c9kwcyg";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb libyubikey json_c ];

  configureFlags = [
    "--with-backend=libusb-1.0"
  ];

  doCheck = true;

  postInstall = ''
    # Don't use 70-yubikey.rules because it depends on ConsoleKit
    install -D -t $out/lib/udev/rules.d 69-yubikey.rules
  '';

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/yubikey-personalization;
    description = "A library and command line tool to personalize YubiKeys";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
