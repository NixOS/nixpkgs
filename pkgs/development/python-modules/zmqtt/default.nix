{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pytest-asyncio,
  pytest-xdist,
  pytestCheckHook,
  typing-extensions,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "zmqtt";
  version = "0.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "faststream-community";
    repo = "zMQTT";
    tag = "v${finalAttrs.version}";
    hash = "sha256-HMGLhrA6xRJu+OR4K4QJZM1HE4PRr7f3wegxVU5gsXc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "uv_build>=0.9.7,<0.11.0" "uv_build"
  '';

  build-system = [ uv-build ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-xdist
    pytestCheckHook
  ];

  pythonImportsCheck = [ "zmqtt" ];

  disabledTestMarks = [ "broker" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Module for asyncio MQTT 3.1.1 and 5.0";
    homepage = "https://github.com/faststream-community/zMQTT";
    changelog = "https://github.com/faststream-community/zMQTT/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
