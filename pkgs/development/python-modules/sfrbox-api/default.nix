{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  click,
  defusedxml,
  fetchFromGitHub,
  mashumaro,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sfrbox-api";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "sfrbox-api";
    tag = "v${version}";
    hash = "sha256-hK4d9wy2+wUp8elEHW0suu9frYPNnwFUlIRvjTXfRkc=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    defusedxml
    mashumaro
  ];

  optional-dependencies = {
    cli = [ click ];
  };

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ]
  ++ lib.concatAttrValues optional-dependencies;

  pythonImportsCheck = [ "sfrbox_api" ];

  meta = {
    description = "Module for the SFR Box API";
    homepage = "https://github.com/hacf-fr/sfrbox-api";
    changelog = "https://github.com/hacf-fr/sfrbox-api/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "sfrbox-api";
  };
}
