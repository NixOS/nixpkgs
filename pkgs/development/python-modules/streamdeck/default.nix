{ lib
, stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "streamdeck";
  version = "0.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0116a376afc18f3abbf79cc1a4409f81472e19197d5641b9e97e697d105cbdc0";
  };

  meta = with lib; {
    broken = stdenv.isDarwin;
    description = "Python library to control the Elgato Stream Deck";
    homepage = "https://github.com/abcminiuser/python-elgato-streamdeck";
    license = licenses.mit;
    maintainers = with maintainers; [ majiir ];
  };
}

