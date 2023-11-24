{ lib
, buildPythonPackage
, fetchFromGitHub
, numpy
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sdds";
  version = "0.4.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "pylhc";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-8tnJAptTUsC0atxM9Dpn90drcprdWrs8fYoX8RDkLyQ=";
  };

  propagatedBuildInputs = [
    numpy
  ];

  nativeCheckInputs = [
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
