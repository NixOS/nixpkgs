{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, six
, click
}:

buildPythonPackage rec {
  pname = "xdis";
  version = "3.8.8";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4d212df8a85ab55a35f6ad71b2c29818d903c3e6a95e31eb26d5f3fc66a4e015";
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
