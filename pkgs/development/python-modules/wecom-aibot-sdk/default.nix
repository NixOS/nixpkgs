{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  # Build system
  hatchling,
  # Dependencies
  cryptography,
  httpx,
  websockets,
  # Optional dependencies
  python-dotenv,
  pytest,
  pytest-asyncio,
  # Tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "wecom-aibot-sdk";
  version = "1.0.7";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "xiaowangzhixiao";
    repo = "wecom-aibot-python-sdk";
    tag = "v${finalAttrs.version}";
    hash = "sha256-34+UByfMw2t1/E+Of58K/s5f6hRc6DPIpVHbDaOoh3Y=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    cryptography
    httpx
    websockets
  ];

  optional-dependencies = {
    examples = [
      python-dotenv
    ];
    test = [
      pytest
      pytest-asyncio
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ] ++ finalAttrs.passthru.optional-dependencies.test;
  pythonImportsCheck = [
    "wecom_aibot_sdk"
  ];
  enabledTestPaths = [
    "tests"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "WeCom Enterprise Chatbot Python SDK";
    homepage = "https://github.com/xiaowangzhixiao/wecom-aibot-python-sdk";
    changelog = "https://github.com/xiaowangzhixiao/wecom-aibot-python-sdk/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ LodWKobku ];
  };
})
