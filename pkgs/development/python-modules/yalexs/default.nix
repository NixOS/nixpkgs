{
  lib,
  aiofiles,
  aiohttp,
  aiointercept,
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

buildPythonPackage (finalAttrs: {
  pname = "yalexs";
  version = "9.2.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Yale-Libs";
    repo = "yalexs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qmNTEHki0c0wpsKAr/oKLDluFs6Md18SXbq8WZapMB4=";
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
    aiointercept
    pytest-asyncio
    pytest-cov-stub
    pytest-freezegun
    pytestCheckHook
    requests-mock
  ];

  disabledTests = [
    # aiohttp api breakage, remove when bumping to 9.2.8 or newer
    "test__raise_response_exceptions"
    "test_async_refresh_token"
  ];

  pythonImportsCheck = [ "yalexs" ];

  meta = {
    description = "Python API for Yale Access (formerly August) Smart Lock and Doorbell";
    homepage = "https://github.com/Yale-Libs/yalexs";
    changelog = "https://github.com/Yale-Libs/yalexs/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
