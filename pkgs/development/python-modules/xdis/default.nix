{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, six
, click
}:

buildPythonPackage rec {
  pname = "xdis";
  version = "3.8.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q2dg3hnsmmpjcc7lzjf5nd041mpbwa2bq3dgr4p6wv65vncny9v";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ six click ];

  # newest release moves to pytest (tests not packaged with release)
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Python cross-version byte-code disassembler and marshal routines";
    homepage = https://github.com/rocky/python-xdis/;
    license = licenses.gpl2;
  };

}
