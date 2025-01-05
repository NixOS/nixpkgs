{
  lib,
  attrs,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  pytz,
  setuptools,
}:

buildPythonPackage rec {
  pname = "serpent";
  version = "1.41";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-BAcDX+PGZEOH1Iz/FGfVqp/v+BTQc3K3hnftDuPtcJU=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    attrs
    pytz
    pytestCheckHook
  ];

  pythonImportsCheck = [ "serpent" ];

  meta = with lib; {
    description = "Simple serialization library based on ast.literal_eval";
    homepage = "https://github.com/irmen/Serpent";
    changelog = "https://github.com/irmen/Serpent/releases/tag/serpent-${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ prusnak ];
  };
}
