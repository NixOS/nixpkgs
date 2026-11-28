{
  buildPythonPackage,
  lib,
  fetchFromGitHub,
  hatchling,
  asgiref,
  brotli,
  django,
  httpx,
  pytestCheckHook,
  pytest-timeout,
}:

buildPythonPackage (finalAttrs: {
  pname = "servestatic";
  version = "4.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Archmonger";
    repo = "ServeStatic";
    tag = "${finalAttrs.version}";
    hash = "sha256-KQJXMDpCv+UVDaqiF7PM/Gly5iHhDPhRhuBe8t9XqnM=";
  };

  build-system = [ hatchling ];

  dependencies = [ asgiref ];

  nativeCheckInputs = [
    brotli
    django
    httpx
    pytestCheckHook
    pytest-timeout
  ];

  disabledTests = [
    # does not work when testing at epoch
    "test_modified"
  ];

  meta = {
    description = "Production-grade Python static file server. Middleware or standalone.";
    homepage = "https://github.com/Archmonger/ServeStatic";
    maintainers = with lib.maintainers; [ ma27 ];
    license = lib.licenses.mit;
  };
})
