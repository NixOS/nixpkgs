{ lib
, buildPythonPackage
, fetchFromGitHub
, lxml
, pytestCheckHook
, python-dateutil
, pythonOlder
}:

buildPythonPackage rec {
  pname = "tcxparser";
  version = "2.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "vkurup";
    repo = "python-tcxparser";
    rev = version;
    hash = "sha256-HOACQpPVg/UKopz3Jdsyg0CIBnXYuVyhWUVPA+OXI0k=";
  };

  propagatedBuildInputs = [
    lxml
    python-dateutil
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "tcxparser"
  ];

  meta = with lib; {
    description = "Simple parser for Garmin TCX files";
    homepage = "https://github.com/vkurup/python-tcxparser";
    license = licenses.bsd2;
    maintainers = with maintainers; [ firefly-cpp ];
  };
}

