{
  lib,
  attrs,
  buildPythonPackage,
  entry-points-txt,
  fetchFromGitHub,
  hatchling,
  headerparser,
  jsonschema,
  packaging,
  pytestCheckHook,
  pytest-cov-stub,
  readme-renderer,
  setuptools,
  wheel-filename,
}:

buildPythonPackage rec {
  pname = "wheel-inspect";
  version = "1.8.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jwodder";
    repo = "wheel-inspect";
    tag = "v${version}";
    hash = "sha256-yECgJLShCLiEyZmw9azNP5lwLeas10AfRu/RVMQGejg=";
  };

  pythonRelaxDeps = [
    "entry-points-txt"
    "headerparser"
  ];

  build-system = [ hatchling ];

  dependencies = [
    attrs
    entry-points-txt
    headerparser
    packaging
    readme-renderer
    wheel-filename
  ];

  nativeCheckInputs = [
    setuptools
    pytestCheckHook
    pytest-cov-stub
    jsonschema
  ];

  pythonImportsCheck = [ "wheel_inspect" ];

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  meta = {
    description = "Extract information from wheels";
    homepage = "https://github.com/jwodder/wheel-inspect";
    changelog = "https://github.com/wheelodex/wheel-inspect/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ayazhafiz ];
    mainProgram = "wheel2json";
  };
}
