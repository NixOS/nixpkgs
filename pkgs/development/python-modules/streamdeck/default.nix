{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  substituteAll,
  pkgs,
}:

buildPythonPackage rec {
  pname = "streamdeck";
  version = "0.9.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7ELZtxGzUuonStMFputI7OHu06W//nC5KOCC3OD3iPA=";
  };

  patches = [
    # substitute libusb path
    (substituteAll {
      src = ./hardcode-libusb.patch;
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
