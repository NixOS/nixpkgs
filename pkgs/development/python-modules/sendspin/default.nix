{
  lib,
  aiosendspin-mpris,
  aiosendspin,
  av,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pulsectl-asyncio,
  pychromecast,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  qrcode,
  readchar,
  rich,
  setuptools,
  sounddevice,
  textual-image,
}:

buildPythonPackage (finalAttrs: {
  pname = "sendspin";
  version = "7.5.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Sendspin";
    repo = "sendspin-cli";
    tag = finalAttrs.version;
    hash = "sha256-Oux9hEtN5AiPf3gAqXGVinDfDIuNVugchUNuLMfMoYc=";
  };

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiosendspin
    aiosendspin-mpris
    av
    numpy
    pulsectl-asyncio
    qrcode
    readchar
    rich
    sounddevice
    textual-image
  ]
  ++ aiosendspin.optional-dependencies.server;

  optional-dependencies = {
    cast = [ pychromecast ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "sendspin" ];

  disabledTests = [
    # requires internet
    "test_multi_worker_starts_and_serves_status"
  ];

  meta = {
    description = "Synchronized audio player for Sendspin servers";
    homepage = "https://github.com/Sendspin/sendspin-cli";
    changelog = "https://github.com/Sendspin/sendspin-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
