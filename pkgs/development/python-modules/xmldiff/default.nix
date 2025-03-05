{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchPypi,
  lxml,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "xmldiff";
  version = "2.7.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wJELH4ADZt1+xikj5dBuiwahvZEgVpocJ/TyRGucaKI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    lxml
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xmldiff" ];

  meta = with lib; {
    description = "Creates diffs of XML files";
    homepage = "https://github.com/Shoobx/xmldiff";
    changelog = "https://github.com/Shoobx/xmldiff/blob/master/CHANGES.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ sfrijters ];
  };
}
