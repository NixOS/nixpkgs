{
  buildPythonPackage,
  home-assistant,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
  ruff,
}:

buildPythonPackage {
  pname = "hassfest";
  pyproject = true;

  inherit (home-assistant) version src;

  sourceRoot = "${home-assistant.src.name}/packages/hassfest";

  build-system = [ setuptools ];

  pythonImportsCheck = [ "hassfest" ];

  nativeCheckInputs = [
    pytestCheckHook
    ruff
  ];

  meta = home-assistant.meta // {
    description = "Validate Home Asisstant integrations";
  };
}
