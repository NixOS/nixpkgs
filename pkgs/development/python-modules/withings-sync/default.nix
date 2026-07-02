{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  garminconnect,
  importlib-resources,
  lxml,
  poetry-core,
  python-dotenv,
  requests,
}:

buildPythonPackage (finalAttrs: {
  pname = "withings-sync";
  version = "6.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaroslawhartman";
    repo = "withings-sync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-z0rVUFBbPff6xfItLQqbt+uN5Qe/BbVLAH1xMVUSfpA=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "1.0.0.dev1" "${finalAttrs.version}"
  '';

  pythonRelaxDeps = [ "garminconnect" ];

  build-system = [ poetry-core ];

  dependencies = [
    garminconnect
    importlib-resources
    lxml
    python-dotenv
    requests
  ];

  pythonImportsCheck = [ "withings_sync" ];

  meta = {
    description = "Synchronisation of Withings weight";
    homepage = "https://github.com/jaroslawhartman/withings-sync";
    changelog = "https://github.com/jaroslawhartman/withings-sync/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "withings-sync";
  };
})
