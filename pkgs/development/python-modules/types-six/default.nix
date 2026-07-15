{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-six";
  version = "1.17.0.20260518";
  pyproject = true;

  src = fetchPypi {
    pname = "types_six";
    inherit (finalAttrs) version;
    hash = "sha256-sBltUYi9WJvFq5KQHtwaT/PF/UsNwZ0HSl8fghPlITo=";
  };

  build-system = [ setuptools ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [
    "six-stubs"
  ];

  meta = {
    description = "Typing stubs for six";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ YorikSar ];
  };
})
