{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "xlrd";
  version = "2.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9y8Uj1RELGsFa/kx28NPmG/Qw7C2taWNATya7ydNDIg=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  # No tests in archive
  doCheck = false;

  meta = with lib; {
    homepage = "https://www.python-excel.org/";
    description = "Library for developers to extract data from Microsoft Excel (tm) spreadsheet files";
    mainProgram = "runxlrd.py";
    license = licenses.bsd0;
  };
}
