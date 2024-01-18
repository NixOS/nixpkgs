{ lib
, buildPythonPackage
, fetchFromGitHub
, garth
, lxml
, python-dotenv
, pythonOlder
, requests
, setuptools
}:

buildPythonPackage rec {
  pname = "withings-sync";
  version = "4.2.2";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jaroslawhartman";
    repo = "withings-sync";
    rev = "refs/tags/v${version}";
    hash = "sha256-p1coGTbMQ+zptFKVLW5qgSdoudo2AggGT8Xu+cSCCs4=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    garth
    lxml
    python-dotenv
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
