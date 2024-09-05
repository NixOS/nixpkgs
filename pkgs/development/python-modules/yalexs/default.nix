{
  lib,
  aiofiles,
  aiohttp,
  aioresponses,
  aiounittest,
  buildPythonPackage,
  ciso8601,
  fetchFromGitHub,
  freenub,
  poetry-core,
  pyjwt,
  pytestCheckHook,
  python-dateutil,
  python-socketio,
  pythonOlder,
  pytest-asyncio,
  pytest-cov-stub,
  requests-mock,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "yalexs";
  version = "8.6.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "yalexs";
    rev = "refs/tags/v${version}";
    hash = "sha256-z01q+sUuj9BvcN56+c3vti8xUnWhYGuV/BTXhvcTl30=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "aiohttp" ];

  dependencies = [
    aiofiles
    aiohttp
    ciso8601
    freenub
    pyjwt
    python-dateutil
    python-socketio
    requests
    typing-extensions
  ] ++ python-socketio.optional-dependencies.asyncio_client;

  nativeCheckInputs = [
    aioresponses
    aiounittest
    pytestCheckHook
    pytest-asyncio
    pytest-cov-stub
    requests-mock
  ];

  pythonImportsCheck = [ "yalexs" ];

  meta = with lib; {
    description = "Python API for Yale Access (formerly August) Smart Lock and Doorbell";
    homepage = "https://github.com/bdraco/yalexs";
    changelog = "https://github.com/bdraco/yalexs/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
