{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "xlwt";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-xZkScXqbKPGjwqmP1gdBAUsGsEOTbc7LwRPqqtoVbIg=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "xlwt" ];

  meta = with lib; {
    description = "Library to create spreadsheet files compatible with MS";
    homepage = "https://github.com/python-excel/xlwt";
    license = with licenses; [
      bsdOriginal
      bsd3
      lgpl21Plus
    ];
    maintainers = with maintainers; [ ];
  };
}
