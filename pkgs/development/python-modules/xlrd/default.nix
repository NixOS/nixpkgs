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
    sha256 = "f72f148f54442c6b056bf931dbc34f986fd0c3b0b6b5a58d013c9aef274d0c88";
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
