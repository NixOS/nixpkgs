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
  version = "4.3.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Archmonger";
    repo = "ServeStatic";
    tag = "${finalAttrs.version}";
    hash = "sha256-zm6wR+LZkmdooB9lXY8EVAhatd2eRMmBtHpV6Z7+Ey0=";
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
