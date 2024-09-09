{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "uritemplate";
  version = "4.1.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Q0bt/Fw7efaUvM1tYJmjIrvrYo2/LNhu6lWkVs5RJPA=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "uritemplate" ];

  meta = with lib; {
    description = "Implementation of RFC 6570 URI templates";
    homepage = "https://github.com/python-hyper/uritemplate";
    changelog = "https://github.com/python-hyper/uritemplate/blob/${version}/HISTORY.rst";
    license = with licenses; [
      asl20
      bsd3
    ];
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
