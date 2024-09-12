{
  lib,
  buildPythonPackage,
  click,
  defusedxml,
  fetchFromGitHub,
  httpx,
  poetry-core,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  respx,
}:

buildPythonPackage rec {
  pname = "sfrbox-api";
  version = "0.0.10";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "hacf-fr";
    repo = "sfrbox-api";
    rev = "refs/tags/v${version}";
    hash = "sha256-xvtusgqCseXAmiPQBFFZnRS9KmuhzHhZUAj5aaqyFrE=";
  };

  pythonRelaxDeps = [
    "defusedxml"
    "pydantic"
  ];

  build-system = [ poetry-core ];

  dependencies = [
    defusedxml
    httpx
    pydantic
  ];

  passthru.optional-dependencies = {
    cli = [ click ];
  };

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    respx
  ] ++ lib.flatten (builtins.attrValues passthru.optional-dependencies);

  pythonImportsCheck = [ "sfrbox_api" ];

  meta = with lib; {
    description = "Module for the SFR Box API";
    homepage = "https://github.com/hacf-fr/sfrbox-api";
    changelog = "https://github.com/hacf-fr/sfrbox-api/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "sfrbox-api";
  };
}
