{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
}:

buildPythonPackage rec {
  pname = "xlrd";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "546eb36cee8db40c3eaa46c351e67ffee6eeb5fa2650b71bc4c758a29a1b29b2";
  };

  checkInputs = [ pytest ];

  checkPhase = ''
    py.test -k "not test_tilde_path_expansion"
  '';

  meta = with stdenv.lib; {
    homepage = http://www.python-excel.org/;
    description = "Library for developers to extract data from Microsoft Excel (tm) spreadsheet files";
    license = licenses.bsd0;
  };

}
