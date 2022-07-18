{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, pythonOlder
}:

buildPythonPackage rec {
  pname = "smbus2";
  version = "0.4.2";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kplindegaard";
    repo = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-6JzFbhUq8XR1nYkadPeYqItcLZDIFAwTe3BriEW2nVI=";
  };

  checkInputs = [
    nose
  ];

  checkPhase = ''
    runHook preCheck
    nosetests
    runHook postCheck
  '';

  pythonImportsCheck = [
    "smbus2"
  ];

  meta = with lib; {
    description = "Drop-in replacement for smbus-cffi/smbus-python";
    homepage = "https://smbus2.readthedocs.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
