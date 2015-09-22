{ stdenv, fetchurl, pkgconfig, libusb, libyubikey, json_c }:

stdenv.mkDerivation rec {
  name = "yubikey-personalization-${version}";
  version = "1.17.2";

  src = fetchurl {
    url = "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-${version}.tar.gz";
    sha256 = "1z6ybpdhl74phwzg2lhxhipqf7xnfhg52dykkzb3fbx21m0i4jkh";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb libyubikey json_c ];

  configureFlags = [
    "--with-backend=libusb-1.0"
  ];

  postInstall = ''
    mkdir -p $out/lib/udev/rules.d/
    cp -v *.rules $out/lib/udev/rules.d/
  '';

  meta = with stdenv.lib; {
    homepage = https://developers.yubico.com/yubikey-personalization;
    description = "a library and command line tool to personalize YubiKeys";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = with maintainers; [ wkennington ];
  };
}
