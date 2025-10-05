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
  propcache,
  pyjwt,
  pytest-asyncio,
  pytest-cov-stub,
  pytest-freezegun,
  pytestCheckHook,
  python-dateutil,
  python-socketio,
  requests-mock,
  requests,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "yalexs";
  version = "9.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "yalexs";
    tag = "v${version}";
    hash = "sha256-t7C2x3aH3ltDthBlt+ghSj9SEfZ4jm4Fgs0KAIm7cBA=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = [ "aiohttp" ];

  dependencies = [
    aiofiles
    aiohttp
    ciso8601
    freenub
    propcache
    pyjwt
    python-dateutil
    python-socketio
    requests
    typing-extensions
  ]
  ++ python-socketio.optional-dependencies.asyncio_client;

  nativeCheckInputs = [
    aioresponses
    aiounittest
    pytest-asyncio
    pytest-cov-stub
    pytest-freezegun
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "yalexs" ];

  meta = with lib; {
    description = "Python API for Yale Access (formerly August) Smart Lock and Doorbell";
    homepage = "https://github.com/bdraco/yalexs";
    changelog = "https://github.com/bdraco/yalexs/blob/${src.tag}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
