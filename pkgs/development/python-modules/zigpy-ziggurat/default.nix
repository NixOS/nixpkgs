{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  aiospinel,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  zigpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "zigpy-ziggurat";
  version = "1.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-ziggurat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bZz4GpL5p1fdKSXiKfcOMh0nr//RaAQXC0dBXI5d7EM=";
  };

  postPatch = ''
    # falls back to wrong version
    substituteInPlace pyproject.toml \
      --replace-fail ', "setuptools-git-versioning<3"' ""
  '';

  nativeBuildInputs = [
    pyprojectVersionPatchHook
  ];

  build-system = [
    setuptools
  ];

  dependencies = [
    aiohttp
    aiospinel
    zigpy
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "zigpy_ziggurat"
  ];

  meta = {
    description = "Zigpy radio library for communicating with the Ziggurat stack";
    homepage = "https://github.com/zigpy/zigpy-ziggurat";
    changelog = "https://github.com/zigpy/zigpy-ziggurat/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
