{
  lib,
  attrs,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "serpent";
  version = "1.43";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-YtwkL9TqKlAzn09aqvbsxVYF7nR3DX6yAx52DZCg0RQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    attrs
    pytz
    pytestCheckHook
  ];

  pythonImportsCheck = [ "serpent" ];

  meta = {
    description = "Simple serialization library based on ast.literal_eval";
    homepage = "https://github.com/irmen/Serpent";
    changelog = "https://github.com/irmen/Serpent/releases/tag/serpent-${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
