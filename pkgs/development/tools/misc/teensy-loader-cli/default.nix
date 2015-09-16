{ stdenv, fetchurl, unzip, libusb, fetchgit }:
let
  version = "2.1";
in
stdenv.mkDerivation {
  name = "teensy-loader-cli-${version}";
  src = fetchgit {
    url = "git://github.com/PaulStoffregen/teensy_loader_cli.git";
    rev = "001da416bc362ff24485ff97e3a729bd921afe98";
    sha256 = "36aed0a725055e36d71183ff57a023993099fdc380072177cffc7676da3c3966";
  };

  buildInputs = [ unzip libusb ];

  installPhase = ''
    install -Dm755 teensy_loader_cli $out/bin/teensy-loader-cli
  '';

  meta = with stdenv.lib; {
    license = licenses.gpl3;
    description = "Firmware uploader for the Teensy microcontroller boards";
    homepage = http://www.pjrc.com/teensy/;
    maintainers = with maintainers; [ the-kenny ];
    platforms = platforms.linux;
  };
}
