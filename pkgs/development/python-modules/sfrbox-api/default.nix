{
  lib,
  buildPythonPackage,
  click,
  defusedxml,
  fetchFromGitHub,
  httpx,
  mashumaro,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  respx,
}:

buildPythonPackage rec {
  pname = "sfrbox-api";
  version = "0.0.12";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "sfrbox-api";
    tag = "v${version}";
    hash = "sha256-LUQwBzNNuH+hBAGAF7Qcc22I6u53rh+RDRrUuy9xhu8=";
  };

  pythonRelaxDeps = [
    "defusedxml"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    defusedxml
    mashumaro
    httpx
  ];

  optional-dependencies = {
    cli = [ click ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    respx
  ]
  ++ lib.flatten (builtins.attrValues optional-dependencies);

  pythonImportsCheck = [ "sfrbox_api" ];

  meta = with lib; {
    description = "Module for the SFR Box API";
    homepage = "https://github.com/hacf-fr/sfrbox-api";
    changelog = "https://github.com/hacf-fr/sfrbox-api/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "sfrbox-api";
  };
}
