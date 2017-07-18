{ stdenv, fetchzip }:
let
  osName = if stdenv.isDarwin then "DARWIN" else "LINUX";
in stdenv.mkDerivation rec {
  name = "hid-listen";
  version = "1.01";

  src = fetchzip {
    name = "hid_listen_${version}";
    url = "https://www.pjrc.com/teensy/hid_listen_${version}.zip";
    sha256 = "0sd4dvi39fl4vy880mg531ryks5zglfz5mdyyqr7x6qv056ffx9w";
  };

  # if we don't set CC explictly, the Makefile defaults to gcc which won't work
  # on Darwin (darwin uses clang)
  buildFlags = ["CC=cc" "OS=${osName}"];

  installPhase = ''
    mkdir -p $out/bin
    mv ./hid_listen $out/bin/hid_listen
  '';

  meta = with stdenv.lib; {
    description = "A tool thats prints debugging information from usb HID devices";
    homepage = https://www.pjrc.com/teensy/hid_listen.html;
    license = licenses.gpl3;
    maintainers = with maintainers; [ tomsmeets ];
    platforms = platforms.all;
  };
}
