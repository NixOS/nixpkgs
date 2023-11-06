{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
}:

buildPythonPackage rec {
  pname = "tlds";
  version = "2023102600";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kichik";
    repo = "tlds";
    rev = "refs/tags/${version}";
    hash = "sha256-ncbgR/syMChIL0/FGLOHxHJMUzH0G+rZX9aCXun7yc4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

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
