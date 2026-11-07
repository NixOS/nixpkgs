{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  prometheus-client,
  starlette,
  pytestCheckHook,
  httpx2,
}:
buildPythonPackage (finalAttrs: {
  pname = "starlette-exporter";
  version = "0.23.0";
  pyproject = true;
  __structuredAttrs = true;
  src = fetchFromGitHub {
    owner = "stephenhillier";
    repo = "starlette_exporter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OfuiOBpyLQoiwTx/pz3md8dmbqo9vohkcXvudcZrk2U=";
  };

  dependencies = [
    starlette
    prometheus-client
  ];

  nativeCheckInputs = [
    pytestCheckHook
    httpx2
  ];

  build-system = [ setuptools ];

  pythonInputCheck = [ "starlette_exporter" ];
  meta = {
    description = "Prometheus metrics exporter for Starlette applications";
    homepage = "https://github.com/stephenhillier/starlette_exporter";
    changelog = "https://github.com/stephenhillier/starlette_exporter/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mhdask ];
  };
})
