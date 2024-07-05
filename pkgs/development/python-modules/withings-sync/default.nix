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
  version = "4.2.4";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jaroslawhartman";
    repo = "withings-sync";
    rev = "refs/tags/v.${version}";
    hash = "sha256-nFYEtQob3x6APWDKCVP5p+qkKmgvXIcmegp/6ZRbDQA=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    garth
    lxml
    python-dotenv
    requests
  ];

  pythonImportsCheck = [ "withings_sync" ];

  meta = with lib; {
    description = "Synchronisation of Withings weight";
    mainProgram = "withings-sync";
    homepage = "https://github.com/jaroslawhartman/withings-sync";
    changelog = "https://github.com/jaroslawhartman/withings-sync/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
