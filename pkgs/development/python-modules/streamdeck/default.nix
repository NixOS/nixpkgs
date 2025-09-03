{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  replaceVars,
  pkgs,
}:

buildPythonPackage rec {
  pname = "streamdeck";
  version = "0.9.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jVhuZihvjuA5rwl55JAmtFq+h/f5M68Vo44jh8HjUI4=";
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
    description = "Python library to control the Elgato Stream Deck";
    homepage = "https://github.com/abcminiuser/python-elgato-streamdeck";
    license = licenses.mit;
    maintainers = with maintainers; [ majiir ];
  };
}
