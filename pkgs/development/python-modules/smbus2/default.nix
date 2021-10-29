{ lib
, buildPythonPackage
, fetchFromGitHub
, nose
, pythonOlder
}:

buildPythonPackage rec {
  pname = "smbus2";
  version = "0.4.1";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "kplindegaard";
    repo = pname;
    rev = version;
    sha256 = "0xgqs7bzhr8y3irc9gq3dnw1l3f5gc1yv4r2v4qxj95i3vvzpg5s";
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
