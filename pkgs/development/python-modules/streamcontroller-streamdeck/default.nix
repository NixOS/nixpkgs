{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  replaceVars,
  pkgs,
}:

buildPythonPackage rec {
  pname = "streamcontroller_streamdeck";
  version = "0.1.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JSDCg9PLDqxM1KdoCEnYzJip71re6rdS/mLn6fsGn9E=";
  };

  patches = [
    # substitute libusb path
    (replaceVars ./hardcode-libusb.patch {
      libusb = "${pkgs.hidapi}/lib/libhidapi-libusb${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  pythonImportsCheck = [ "StreamDeck" ];
  doCheck = false;

  meta = with lib; {
    # This is a fork of abcminiuser/python-elgato-streamdeck targeted at StreamController.
    description = "Python library to control the Elgato Stream Deck";
    homepage = "https://github.com/StreamController/streamcontroller-python-elgato-streamdeck";
    license = licenses.mit;
    maintainers = with maintainers; [
      majiir
      sifmelcara
    ];
  };
}
