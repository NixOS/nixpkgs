{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  poetry-core,
  pyhamcrest,
  pytestCheckHook,
  requests-mock,
  requests,
  six,
}:

buildPythonPackage (finalAttrs: {
  pname = "zaproxy";
  version = "0.6.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "zaproxy";
    repo = "zap-api-python";
    tag = finalAttrs.version;
    hash = "sha256-a0F6asx8Dl1T/OqNhHukHRbq+LUqsl3im+y1k096pfE=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    requests
    six
  ];

  nativeCheckInputs = [
    pyhamcrest
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [ "zapv2" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ZAP Python API";
    homepage = "https://github.com/zaproxy/zap-api-python";
    changelog = "https://github.com/zaproxy/zap-api-python/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
