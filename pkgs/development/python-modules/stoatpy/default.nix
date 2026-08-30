{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  setuptools,

  aiohttp,
  attrs,

  pytestCheckHook,

  orjson,
  aiodns,
  brotli,

  pytest-asyncio,
  typing-extensions,
}:
buildPythonPackage (finalAttrs: {
  pname = "stoatpy";
  version = "1.2.1-unstable-2026-05-03";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "MCausc78";
    repo = "stoat.py";
    rev = "b8f6b2d65e24fe40548872c63ce648beac54ef9a";
    hash = "sha256-hAwgzT8YvUuqBluRzHTASowJaOqp+bfOtJgxfypMDzI=";
  };

  patches = [ ./fix-tests.patch ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    attrs
  ]
  ++ finalAttrs.passthru.optional-dependencies.speed;

  pythonImportsCheck = [ "stoat" ];

  nativeCheckInputs = [
    pytestCheckHook
  ]
  ++ finalAttrs.passthru.optional-dependencies.test;

  passthru.optional-dependencies = {
    speed = [
      orjson
      aiodns
      brotli
    ];

    test = [
      pytest-asyncio
      typing-extensions
    ];
  };

  meta = {
    description = "Simple, flexible API wrapper for Stoat";
    homepage = "https://github.com/MCausc78/stoat.py";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ryand56 ];
  };
})
