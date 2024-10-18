{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  garth,
  lxml,
  python-dotenv,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "withings-sync";
  version = "4.2.5";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jaroslawhartman";
    repo = "withings-sync";
    rev = "refs/tags/v${version}";
    hash = "sha256-4gxJwe8v4trTysGBNORX7C54EUzFIPwpVLfKSNxJ8y4=";
  };

  build-system = [ setuptools ];

  dependencies = [
    garth
    lxml
    python-dotenv
    requests
  ];

  pythonImportsCheck = [ "withings_sync" ];

  meta = with lib; {
    description = "Synchronisation of Withings weight";
    homepage = "https://github.com/jaroslawhartman/withings-sync";
    changelog = "https://github.com/jaroslawhartman/withings-sync/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "withings-sync";
  };
}
