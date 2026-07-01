{
  lib,
  aiofiles,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  pythonOlder,
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
  version = "9.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "yalexs";
    tag = "v${version}";
    hash = "sha256-HZN3ot5z/JbWZaWLffyTWLneD1gG3tTdYLKevXYnJnw=";
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
    pytest-asyncio
    pytest-cov-stub
    pytest-freezegun
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "yalexs" ];

  # aiounittest doesn't work with python 3.14
  # https://github.com/Yale-Libs/yalexs/issues/335
  doCheck = pythonOlder "3.14";

  meta = {
    description = "Python API for Yale Access (formerly August) Smart Lock and Doorbell";
    homepage = "https://github.com/bdraco/yalexs";
    changelog = "https://github.com/bdraco/yalexs/blob/${src.tag}/CHANGELOG.md";
    license = with lib.licenses; [ mit ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
