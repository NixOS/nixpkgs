{ lib
, buildPythonPackage
, fetchPypi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "six";
  version = "1.16.0";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926";
  };

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "six" ];

  meta = {
    changelog = "https://github.com/benjaminp/six/blob/${version}/CHANGES";
    description = "Python 2 and 3 compatibility library";
    homepage = "https://github.com/benjaminp/six";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
