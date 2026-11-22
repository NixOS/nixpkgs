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
  version = "2.2.14";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-VUTZvyKeum3Ic3wY3iiwayIsbwmS8OXNBCyLLp45fsI=";
  };

  build-system = [ hatchling ];

  dependencies = lib.optionals (pythonOlder "3.12") [
    typing-extensions
  ];

  pythonImportsCheck = [ "tomlrt" ];

  meta = {
    description = "A format-preserving TOML reader and writer for Python";
    homepage = "https://github.com/dimbleby/tomlrt";
    changelog = "https://github.com/dimbleby/tomlrt/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ aaronjheng ];
  };
})
