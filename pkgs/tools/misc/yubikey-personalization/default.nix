{ lib, stdenv, fetchurl, fetchpatch, pkg-config, libusb1, libyubikey, json_c }:

stdenv.mkDerivation rec {
  pname = "yubikey-personalization";
  version = "1.20.0";

  src = fetchurl {
    url = "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-${version}.tar.gz";
    sha256 = "14wvlwqnwj0gllkpvfqiy8ns938bwvjsz8x1hmymmx32m074vj0f";
  };

  patches = [
    # remove after updating to next release
    (fetchpatch {
      name = "json-c-0.14-support.patch";
      url = "https://github.com/Yubico/yubikey-personalization/commit/0aa2e2cae2e1777863993a10c809bb50f4cde7f8.patch";
      sha256 = "1wnigf3hbq59i15kgxpq3pwrl1drpbj134x81mmv9xm1r44cjva8";
    })

    # Pull upstream fix for -fno-common toolchain support:
    #  https://github.com/Yubico/yubikey-personalization/issues/155
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/Yubico/yubikey-personalization/commit/09ea16d9e2030e4da6ad00c1e5147e962aa7ff84.patch";
      sha256 = "0n3ka8n7f3ndbxv3k0bi77d850kr2ypglkw81gqycpqyaciidqwa";
    })
  ];

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 libyubikey json_c ];

  configureFlags = [
    "--with-backend=libusb-1.0"
  ];

  doCheck = true;

  postInstall = ''
    # Don't use 70-yubikey.rules because it depends on ConsoleKit
    install -D -t $out/lib/udev/rules.d 69-yubikey.rules
  '';

  meta = with lib; {
    homepage = "https://developers.yubico.com/yubikey-personalization";
    description = "A library and command line tool to personalize YubiKeys";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
