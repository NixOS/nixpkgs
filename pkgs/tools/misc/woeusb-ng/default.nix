{ lib, fetchurl, python3Packages }:

python3Packages.buildPythonApplication rec {
  pname = "woeusb-ng";
  version = "0.2.8";

  doCheck = false;

  src = fetchurl {
    url = "https://github.com/WoeUSB/WoeUSB-ng/archive/refs/tags/v${version}.tar.gz";
    sha256 = "8a7e0bd6ced96a02d7a3ad829073809a67d20e6099104ce0a9f5234699a07666";
  };

  propagatedBuildInputs = with python3Packages; [
    wxPython_4_1
    termcolor
    pillow
    six
    numpy
  ];

  meta = with lib; {
    homepage = "https://github.com/WoeUSB/WoeUSB-ng";
    description = "A Linux program to create a Windows USB stick installer from a real Windows DVD or image.";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ felixsinger ];
  };
}
