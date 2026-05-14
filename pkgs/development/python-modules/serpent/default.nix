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
  version = "1.42";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jqCCsB+LoH7NdONKkRisRSG8RZSTjZErgIyJ8dpCVQY=";
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
