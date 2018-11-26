{ stdenv
, buildPythonPackage
, fetchPypi
, nose
}:

buildPythonPackage rec {
  pname = "xlrd";
  version = "0.9.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e8d3359f39541a6ff937f4030db54864836a06e42988c452db5b6b86d29ea72";
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
