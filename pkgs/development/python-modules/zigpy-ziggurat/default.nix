{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  mashumaro,
  pyprojectVersionPatchHook,
  pytest-asyncio,
  pytestCheckHook,
  zigpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "zigpy-ziggurat";
  version = "1.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "zigpy";
    repo = "zigpy-ziggurat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/yOj4ktxEmfFCiZwJVrYqY0PXnZUi8/LwuaUgxTfBCs=";
  };

  postPatch = ''
    # finds version 0.0.1 instead of 1.0.1
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
    mashumaro
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
