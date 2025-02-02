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
  version = "4.2.7";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "jaroslawhartman";
    repo = "withings-sync";
    rev = "refs/tags/v${version}";
    hash = "sha256-ySl2nRR8t7c3NhjgjSzLQ+hcJuh+kx5aoaVPJF56HR0=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "1.0.0.dev1" "${version}"
  '';

  pythonRelaxDeps = true;

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
