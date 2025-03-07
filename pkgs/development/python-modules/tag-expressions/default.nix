{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "tag-expressions";
  version = "2.0.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "tag_expressions";
    inherit version;
    hash = "sha256-EbSwfAH+sL3JGW+COfDA2f7cLGyKmQMsbyyDGy13Lkg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "tagexpressions" ];

  meta = with lib; {
    description = "Package to parse logical tag expressions";
    homepage = "https://github.com/timofurrer/tag-expressions";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ kalbasit ];
  };
}
