{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  hatch-vcs,
  hatch-fancy-pypi-readme,
  attrs,
  # test dependencies
  pytestCheckHook,
  aiohttp,
  fastapi,
  flask,
  httpx,
  pyramid,
  pytest-asyncio,
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
    hatchling
    hatch-vcs
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    attrs
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    sybil
    aiohttp
    fastapi
    flask
    pyramid
    starlette
    httpx
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
