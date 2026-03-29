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

buildPythonPackage (finalAttrs: {
  pname = "withings-sync";
  version = "5.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jaroslawhartman";
    repo = "withings-sync";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1pDM5paSXPQCOG5LRFxnp19K1iHcsfrGC9e7SEyxUDs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "1.0.0.dev1" "${finalAttrs.version}"
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
    changelog = "https://github.com/jaroslawhartman/withings-sync/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "withings-sync";
  };
})
