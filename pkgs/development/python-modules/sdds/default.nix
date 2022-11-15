{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sdds";
  version = "0.3.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pylhc";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-lb4awMQ7GE7m2N2yiCpJ976I2j8hE98/93zCX7Rp4qU=";
  };

  propagatedBuildInputs = [
    numpy
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "sdds"
  ];

  meta = with lib; {
    description = "Module to handle SDDS files";
    homepage = "https://pylhc.github.io/sdds/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
