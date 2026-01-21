{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sentinels";
  version = "1.1.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-PC9k91QYfBngoaApsUi3TPWN0S7Ce04ZwOXW4itamoY=";
  };

  propagatedBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "sentinels" ];

  meta = {
    homepage = "https://github.com/vmalloc/sentinels/";
    description = "Various objects to denote special meanings in python";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ gador ];
  };
}
