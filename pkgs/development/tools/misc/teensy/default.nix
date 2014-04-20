{ stdenv, fetchurl, unzip, libusb }:
let
  version = "2.1";
in
stdenv.mkDerivation {
  name = "teensy-loader-${version}";
  src = fetchurl {
    url = "http://www.pjrc.com/teensy/teensy_loader_cli.2.1.zip";
    sha256 = "0iidj3q0l2hds1gaadnwgni4qdgk6r0nv101986jxda8cw6h9zfs";
  };

  buildInputs = [ unzip libusb ];

  installPhase = ''
    mkdir -p $out/bin
    cp -v teensy_loader_cli $out/bin/
  '';

  meta = with stdenv.lib; {
    license = licenses.gpl3;
    description = "Firmware uploader for the Teensy microcontroller board";
    homepage = http://www.pjrc.com/teensy/;
    maintainers = with maintainers; [ the-kenny ];
    platforms = platforms.linux;
  };
}
