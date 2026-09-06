{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  serialx,
  uv-build,
}:

buildPythonPackage (finalAttrs: {
  pname = "tonewinner-rs232";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "emma-sg";
    repo = "tonewinner-rs232";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zi7yjEv1GXBfETiHLs7RbQNk1z5jK35wHEs49/z/mjw=";
  };

  build-system = [ uv-build ];

  dependencies = [ serialx ] ++ serialx.optional-dependencies.esphome;

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tonewinner_rs232" ];

  meta = {
    description = "Async Python library for Tonewinner AV processors over RS232 serial";
    homepage = "https://github.com/emma-sg/tonewinner-rs232";
    changelog = "https://github.com/emma-sg/tonewinner-rs232/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
