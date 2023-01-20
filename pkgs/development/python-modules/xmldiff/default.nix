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
  version = "2.5";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-bF8wvGXOboHZpwo8sCafe6YYUv1sqnoPv8Dt8zs8txc=";
  };

  propagatedBuildInputs = [
    lxml
    setuptools
  ];

  checkInputs = [
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
