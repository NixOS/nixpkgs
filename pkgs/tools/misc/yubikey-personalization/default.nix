{ stdenv, fetchurl, pkgconfig, libusb, libyubikey, json_c }:

stdenv.mkDerivation rec {
  name = "yubikey-personalization-${version}";
  version = "1.17.3";

  src = fetchurl {
    url = "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-${version}.tar.gz";
    sha256 = "034wmwinxmngji1ly8nm9q4hg194iwk164y5rw0whnf69ycc6bs8";
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
