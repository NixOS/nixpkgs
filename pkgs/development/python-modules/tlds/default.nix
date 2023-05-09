{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "tlds";
  version = "2023050800";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "mweinelt";
    repo = "python-tlds";
    rev = "refs/tags/${version}";
    hash = "sha256-uXYRkalJGJ2o8ptvKCkMBc/U+9DpgPGxINM8w21ZIKM=";
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
