{ lib
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "xlrd";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f72f148f54442c6b056bf931dbc34f986fd0c3b0b6b5a58d013c9aef274d0c88";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test -k "not test_tilde_path_expansion"
  '';

  meta = with lib; {
    homepage = "http://www.python-excel.org/";
    description = "Library for developers to extract data from Microsoft Excel (tm) spreadsheet files";
    license = licenses.bsd0;
  };

}
