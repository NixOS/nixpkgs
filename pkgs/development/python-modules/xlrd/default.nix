{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "xlrd";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8a21885513e6d915fe33a8ee5fdfa675433b61405ba13e2a69e62ee36828d7e2";
  };

  buildInputs = [ nose ];

  checkPhase = ''
    nosetests -v
  '';

  meta = with stdenv.lib; {
    homepage = http://www.python-excel.org/;
    description = "Library for developers to extract data from Microsoft Excel (tm) spreadsheet files";
    license = licenses.bsd0;
  };

}
