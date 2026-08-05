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
  version = "2.2.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-5lKT84Rl6pz8kKZveOFHuxBqi9veF3N76abxtzicXuo=";
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
