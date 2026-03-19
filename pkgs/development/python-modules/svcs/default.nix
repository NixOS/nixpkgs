{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  attrs,
  hatch-fancy-pypi-readme,
  hatch-vcs,
  hatchling,
  # test dependencies
  aiohttp,
  fastapi,
  flask,
  httpx,
  pyramid,
  pytest-asyncio,
  pytestCheckHook,
  starlette,
  sybil,
}:

buildPythonPackage rec {
  pname = "svcs";
  version = "25.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "hynek";
    repo = "svcs";
    tag = version;
    hash = "sha256-dDPmOKGifAGmAH3TD0NzJvR8lUB5qDWbxIwzHtNeF+4=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatch-vcs
    hatchling
  ];

  dependencies = [
    attrs
  ];

  nativeCheckInputs = [
    aiohttp
    fastapi
    flask
    httpx
    pyramid
    pytest-asyncio
    pytestCheckHook
    starlette
    sybil
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    "test_aclose_registry_ok"
    "test_registrations"
    "test_get_pings"
    "test_client_pool_register_value"
  ];

  pythonImportsCheck = [ "svcs" ];

  meta = {
    description = "Flexible Service Locator for Python";
    homepage = "https://github.com/hynek/svcs";
    changelog = "https://github.com/hynek/svcs/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ taranarmo ];
  };
}
