{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "xlrd";
  version = "2.0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-CLXiXeWPIc5x3H2zs7gQbB+ndvMCTFTkW0WzdOiSNMk=";
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
