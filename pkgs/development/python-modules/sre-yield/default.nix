{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  unittestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "sre-yield";
  version = "1.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "sre_yield";
    inherit (finalAttrs) version;
    hash = "sha256-6U8aKjy6//4dzRXB1U5AGhUX4FKqZMfTFk+I3HYde4o=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "sre_yield" ];

  meta = {
    description = "Python library to efficiently generate all values that can match a given regular expression";
    mainProgram = "demo_sre_yield";
    homepage = "https://github.com/sre-yield/sre-yield";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ danc86 ];
  };
})
