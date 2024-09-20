{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "wurlitzer";
  version = "3.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-v7kUSrnwJIfYArn/idvT+jgtCPc+EtuK3EwvsAzTm9k=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "wurlitzer" ];

  pytestFlagsArray = [ "test.py" ];

  meta = with lib; {
    description = "Capture C-level output in context managers";
    homepage = "https://github.com/minrk/wurlitzer";
    changelog = "https://github.com/minrk/wurlitzer/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
