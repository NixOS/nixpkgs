{
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  setuptools,
  pytestCheckHook,
  matplotlib,
}:

buildPythonPackage (finalAttrs: {
  pname = "squarify";
  version = "0.4.3";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "laserson";
    repo = "squarify";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zSv+6xT9H4WyShRnwjjcNMjY19AFlQ6bw9Mh9p2rL08=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  dependencies = [ matplotlib ];

  pythonImportsCheck = [ "squarify" ];

  meta = {
    homepage = "https://github.com/laserson/squarify";
    description = "Pure Python implementation of the squarify treemap layout algorithm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ veehaitch ];
  };
})
