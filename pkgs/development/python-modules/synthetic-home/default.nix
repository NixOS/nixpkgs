{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  mashumaro,
  pytest-asyncio,
  pytestCheckHook,
  python-slugify,
  pyyaml,
  setuptools,
  syrupy,
}:

buildPythonPackage (finalAttrs: {
  pname = "synthetic-home";
  version = "5.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "synthetic-home";
    tag = finalAttrs.version;
    hash = "sha256-oXZVnw4Oc0jC1TBVTV4EI3Ta1zsqLop+c8uyEzAFpLI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    mashumaro
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    python-slugify
    pyyaml
    syrupy
  ];

  pythonImportsCheck = [ "synthetic_home" ];

  preCheck = ''
    export PATH="$PATH:$out/bin";
  '';

  meta = {
    description = "Library for managing synthetic home device registry";
    homepage = "https://github.com/allenporter/synthetic-home";
    changelog = "https://github.com/allenporter/synthetic-home/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
