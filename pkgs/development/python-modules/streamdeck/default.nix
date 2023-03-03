{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, substituteAll
, pkgs
}:

buildPythonPackage rec {
  pname = "streamdeck";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9bNWsNEW5Di2EZ3z+p8y4Q7GTfIG66b05pTiQcff7HE=";
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
    broken = stdenv.isDarwin;
  };
}
