{
  lib,
  buildPythonPackage,
  configparser,
  fetchFromGitHub,
  nix-update-script,
  packaging,
  requests,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "valhallaapi";
  version = "0.5.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "NextronSystems";
    repo = "valhallaAPI";
    tag = finalAttrs.version;
    hash = "sha256-B4nF1t+d6J7XXu51NjbvIUercBn/pQaXWkWpX99ok/M=";
  };

  build-system = [ setuptools ];

  dependencies = [
    configparser
    packaging
    requests
  ];

  pythonImportsCheck = [ "valhallaAPI" ];

  # Tests require network access
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Valhalla API Client";
    homepage = "https://github.com/NextronSystems/valhallaAPI";
    changelog = "https://github.com/NextronSystems/valhallaAPI/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
