{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  gevent,
  hatchling,
  mypy,
  pytest-asyncio,
  pytest-markdown-docs,
  pytestCheckHook,
  pythonOlder,
  sigtools,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "synchronicity";
  version = "0.11.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "modal-labs";
    repo = "synchronicity";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Uyn4apHILBwjHoMkr52IkcFlaX7jx3WzuzZfvdxcDFo=";
  };

  build-system = [ hatchling ];
  dependencies = [ typing-extensions ];
  optional-dependencies.compile = [ sigtools ];

  nativeCheckInputs = [
    mypy
    pytestCheckHook
    pytest-asyncio
    pytest-markdown-docs
    sigtools
  ]
  ++ lib.optionals (pythonOlder "3.13") [
    gevent
  ];

  disabledTests = [
    # Assert execution time, non-deterministic
    "test_blocking"
    "test_multithreaded"
    "test_nowrap"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Assertion error
    "test_async"
  ];

  pythonImportsCheck = [ "synchronicity" ];

  meta = {
    description = "Export blocking and async library versions from a single async implementation";
    homepage = "https://github.com/modal-labs/synchronicity";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ Kharacternyk ];
  };
})
