{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sdds";
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pylhc";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-l9j+YJ5VNMzL6JW59kq0hQS7XIj53UxW5bNnfdURz/o=";
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
