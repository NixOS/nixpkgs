{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, six
, click
}:

buildPythonPackage rec {
  pname = "xdis";
  version = "3.8.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b00f37296edf2a4fe7b67b5d861c342426d442666d241674fdfc333936bd59bf";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ six click ];

  checkPhase = ''
    make check
  '';

  meta = with stdenv.lib; {
    description = "Python cross-version byte-code disassembler and marshal routines";
    homepage = https://github.com/rocky/python-xdis/;
    license = licenses.gpl2;
  };

}
