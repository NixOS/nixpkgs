{
  anyio,
  asyncclick,
  bleak,
  bleak-retry-connector,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  lib,
  uv-dynamic-versioning,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "togrill-bluetooth";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "elupus";
    repo = "togrill-bluetooth";
    tag = version;
    hash = "sha256-UZul5JEGv0zRcnUsEH2dkIiFt7jNYAc+9RvmDJMxkk0=";
  };

  build-system = [
    hatchling
    uv-dynamic-versioning
  ];

  dependencies = [
    bleak
    bleak-retry-connector
  ];

  optional-dependencies = {
    cli = [
      anyio
      asyncclick
    ];
  };

  pythonImportsCheck = [ "togrill_bluetooth" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/elupus/togrill-bluetooth/releases/tag/${src.tag}";
    description = "Module to handle communication with ToGrill compatible temperature probes";
    homepage = "https://github.com/elupus/togrill-bluetooth";
    license = lib.licenses.mit;
    mainProgram = "togrill-bluetooth";
    maintainers = [ lib.maintainers.dotlambda ];
  };
}
