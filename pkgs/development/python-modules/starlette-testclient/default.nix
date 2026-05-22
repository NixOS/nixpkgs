{
  lib,
  buildPythonPackage,
  fetchPypi,

  # build-system
  hatchling,

  # dependencies
  requests,
  starlette,

  # tests
  anyio,
  dirty-equals,
  pytestCheckHook,
  sniffio,
  trio,
}:

buildPythonPackage (finalAttrs: {
  pname = "starlette-testclient";
  version = "0.4.1";
  pyproject = true;

  src = fetchPypi {
    pname = "starlette_testclient";
    inherit (finalAttrs) version;
    hash = "sha256-npk//hL6tFYGEWJXgTmGYSJi/hXBu23J45zGhpOsH8U=";
  };

  build-system = [ hatchling ];

  dependencies = [
    requests
    starlette
  ];

  nativeCheckInputs = [
    anyio
    dirty-equals
    pytestCheckHook
    sniffio
    trio
  ];

  pytestFlags = [
    # ResourceWarnings from newer anyio fail the suite due to upstream
    # filterwarnings = ["error"] in pyproject.toml
    "-Wignore::ResourceWarning"
  ];

  pythonImportsCheck = [ "starlette_testclient" ];

  meta = {
    description = "Backport of Starlette TestClient using requests";
    homepage = "https://github.com/Kludex/starlette-testclient";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ tembleking ];
  };
})
