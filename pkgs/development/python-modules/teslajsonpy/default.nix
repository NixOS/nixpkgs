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
  version = "3.13.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zabuldon";
    repo = "teslajsonpy";
    tag = "v${version}";
    hash = "sha256-tlw5m8RsBGwVx3h+JlY9rwINMDR6csAt2XefK6AaQWE=";
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
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
