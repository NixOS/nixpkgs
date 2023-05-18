{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, lxml
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "xmldiff";
  version = "2.6.1";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-gbgX7y/Q3pswM2tH/R1GSMmbMGhQJKB7w08sFGQE4Vk=";
  };

  propagatedBuildInputs = [
    lxml
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "xmldiff"
  ];

  meta = with lib; {
    description = "Creates diffs of XML files";
    homepage = "https://github.com/Shoobx/xmldiff";
    changelog = "https://github.com/Shoobx/xmldiff/blob/master/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
