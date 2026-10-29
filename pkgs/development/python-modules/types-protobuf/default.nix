{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  types-futures,
}:

buildPythonPackage (finalAttrs: {
  pname = "types-protobuf";
  version = "6.32.1.20260221";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchPypi {
    pname = "types_protobuf";
    inherit (finalAttrs) version;
    hash = "sha256-bV+wYKYWv7B2y7YbSzw5afX8i+xYEPmi9+ZI7ly8v24=";
  };

  build-system = [ setuptools ];

  dependencies = [ types-futures ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "google-stubs" ];

  meta = {
    description = "Typing stubs for protobuf";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ andersk ];
  };
})
