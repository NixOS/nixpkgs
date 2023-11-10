{ lib
, buildPythonPackage
, fetchFromGitHub
, garth
, lxml
, pythonOlder
, requests
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "withings-sync";
  version = "4.2.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jaroslawhartman";
    repo = "withings-sync";
    rev = "refs/tags/v${version}";
    hash = "sha256-6igjUmgIA077/1SQMt10tRpnLVKxGFNJN1GeLhQLROg=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    garth
    lxml
    requests
  ];

  pythonImportsCheck = [
    "withings_sync"
  ];

  meta = with lib; {
    description = "Synchronisation of Withings weight";
    homepage = "https://github.com/jaroslawhartman/withings-sync";
    changelog = "https://github.com/jaroslawhartman/withings-sync/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
