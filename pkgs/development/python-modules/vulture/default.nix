{
  lib,
  buildPythonPackage,
  fetchPypi,
  pint,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
  toml,
}:

buildPythonPackage (finalAttrs: {
  pname = "vulture";
  version = "2.16";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-+Nn24q8DARZko8bCQMl2Wz85KRfTE1/dym1qaNNZ9xc=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    pint
    pytest-cov-stub
    pytestCheckHook
    toml
  ];

  pythonImportsCheck = [ "vulture" ];

  meta = {
    description = "Finds unused code in Python programs";
    homepage = "https://github.com/jendrikseipp/vulture";
    changelog = "https://github.com/jendrikseipp/vulture/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mcwitt ];
    mainProgram = "vulture";
  };
})
