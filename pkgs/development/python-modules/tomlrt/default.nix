{
  lib,
  fetchPypi,
  hatchling,
  typing-extensions,
  buildPythonPackage,
  pythonOlder,
}:

buildPythonPackage (finalAttrs: {
  pname = "tomlrt";
  version = "2.2.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-oKs4NDSLP0eFnBMGrigrzafHgOgnBFWkwMLb1LQkwIk=";
  };

  build-system = [ hatchling ];

  dependencies = lib.optionals (pythonOlder "3.12") [
    typing-extensions
  ];

  pythonImportsCheck = [ "tomlrt" ];

  meta = {
    description = "A format-preserving TOML reader and writer for Python";
    homepage = "https://github.com/dimbleby/tomlrt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aaronjheng ];
  };
})
