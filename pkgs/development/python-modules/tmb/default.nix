{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tmb";
  version = "0.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "alemuro";
    repo = pname;
    rev = version;
    hash = "sha256-/syHSu9LKLDe3awrgSIHh0hV+raWqKd53f43WagHn9c=";
  };

  VERSION = version;

  propagatedBuildInputs = [
    requests
  ];

  pythonImportsCheck = [
    "tmb"
  ];

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Python library that interacts with TMB API";
    homepage = "https://github.com/alemuro/tmb";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
