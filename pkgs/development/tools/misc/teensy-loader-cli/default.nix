{ stdenv, fetchurl, unzip, libusb, fetchgit }:
let
  version = "2.1";
in
stdenv.mkDerivation {
  name = "teensy-loader-cli-${version}";
  src = fetchgit {
    url = "git://github.com/PaulStoffregen/teensy_loader_cli.git";
    rev = "f5b6d7aafda9a8b014b4bb08660833ca45c136d2";
    sha256 = "1a663bv3lvm7bsf2wcaj2c0vpmniak7w5hwix5qgz608bvm2v781";
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
