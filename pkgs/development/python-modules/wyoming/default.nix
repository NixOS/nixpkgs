{ lib
, buildPythonPackage
, fetchPypi

# tests
, wyoming-faster-whisper
, wyoming-openwakeword
, wyoming-piper
}:

buildPythonPackage rec {
  pname = "wyoming";
  version = "1.2.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-mgNhc8PMRrwfvGZEcgIvQ/P2dysdDo2juvZccvb2C/g=";
  };

  pythonImportsCheck = [
    "wyoming"
  ];

  # no tests
  doCheck = false;

  passthru.tests = {
    inherit
      wyoming-faster-whisper
      wyoming-openwakeword
      wyoming-piper
    ;
  };

  meta = with lib; {
    description = "Protocol for Rhasspy Voice Assistant";
    homepage = "https://pypi.org/project/wyoming/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
