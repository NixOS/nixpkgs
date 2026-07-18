{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  replaceVars,
  pkgs,
  setuptools,
}:

buildPythonPackage rec {
  pname = "streamcontroller-streamdeck";
  version = "0.1.7";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "streamcontroller_streamdeck";
    hash = "sha256-n8MYXsuWGSfOTnYrFItwkQaZlBQvPOwt1GdNP4MDjnY=";
  };

  patches = [
    # substitute libusb path
    (replaceVars ./hardcode-libusb.patch {
      libusb = "${pkgs.hidapi}/lib/libhidapi-libusb${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  build-system = [ setuptools ];

  pythonImportsCheck = [ "StreamDeck" ];
  doCheck = false;

  meta = {
    # This is a fork of abcminiuser/python-elgato-streamdeck targeted at StreamController.
    description = "Python library to control the Elgato Stream Deck";
    homepage = "https://github.com/StreamController/streamcontroller-python-elgato-streamdeck";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      majiir
      sifmelcara
    ];
  };
}
