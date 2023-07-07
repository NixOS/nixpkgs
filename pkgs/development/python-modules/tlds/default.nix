{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "tlds";
  version = "2023050900";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "kichik";
    repo = "tlds";
    rev = "refs/tags/${version}";
    hash = "sha256-Fm2cRhUb1Gsr7mrcym/JjYAeG8f3RDhUnxzYIvpxmQE=";
  };

  pythonImportsCheck = [
    "tlds"
  ];

  # no tests
  doCheck = false;

  meta = with lib; {
    description = "Automatically updated list of valid TLDs taken directly from IANA";
    homepage = "https://github.com/mweinelt/tlds";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
