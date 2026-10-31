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
  version = "4.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Archmonger";
    repo = "ServeStatic";
    tag = "${finalAttrs.version}";
    hash = "sha256-7w+bbY8OLTt55ink5y0upAiY+VSBj1aI7g4EaTSGyLU=";
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
