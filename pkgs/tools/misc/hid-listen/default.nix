{ lib, stdenv, fetchzip }:
stdenv.mkDerivation rec {
  pname = "hid-listen";
  version = "1.01";

  src = fetchzip {
    name = "hid_listen_${version}";
    url = "https://www.pjrc.com/teensy/hid_listen_${version}.zip";
    sha256 = "0sd4dvi39fl4vy880mg531ryks5zglfz5mdyyqr7x6qv056ffx9w";
  };

  installPhase = ''
    mkdir -p $out/bin
    mv ./hid_listen $out/bin/hid_listen
  '';

  meta = with lib; {
    description = "Tool thats prints debugging information from usb HID devices";
    homepage = "https://www.pjrc.com/teensy/hid_listen.html";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tomsmeets ];
    platforms = platforms.linux;
    mainProgram = "hid_listen";
  };
}
