{
  lib,
  aiohttp,
  authcaptureproxy,
  backoff,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  orjson,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  tenacity,
  wrapt,
}:

buildPythonPackage rec {
  pname = "teslajsonpy";
  version = "3.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zabuldon";
    repo = "teslajsonpy";
    tag = "v${version}";
    hash = "sha256-EyyDyRoenKY1ZaPGyQz9WwRYWKRbthrNCdq+ms9LNNU=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    authcaptureproxy
    aiohttp
    backoff
    beautifulsoup4
    httpx
    orjson
    tenacity
    wrapt
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "teslajsonpy" ];

  meta = {
    description = "Python library to work with Tesla API";
    homepage = "https://github.com/zabuldon/teslajsonpy";
    changelog = "https://github.com/zabuldon/teslajsonpy/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
