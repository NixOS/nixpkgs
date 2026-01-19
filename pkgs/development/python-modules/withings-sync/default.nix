{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  garth,
  importlib-resources,
  lxml,
  poetry-core,
  python-dotenv,
  requests,
}:

buildPythonPackage rec {
  pname = "withings-sync";
  version = "5.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaroslawhartman";
    repo = "withings-sync";
    tag = "v${version}";
    hash = "sha256-Q9zOXQIdl4jpCK6a5Xp4kZK67MqudX0thDAkRmdL3AQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "1.0.0.dev1" "${version}"
  '';

  build-system = [ poetry-core ];

  dependencies = [
    garth
    importlib-resources
    lxml
    python-dotenv
    requests
  ];

  pythonImportsCheck = [ "withings_sync" ];

  meta = {
    description = "Synchronisation of Withings weight";
    homepage = "https://github.com/jaroslawhartman/withings-sync";
    changelog = "https://github.com/jaroslawhartman/withings-sync/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "withings-sync";
  };
}
