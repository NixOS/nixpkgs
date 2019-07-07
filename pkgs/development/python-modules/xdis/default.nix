{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, six
, click
}:

buildPythonPackage rec {
  pname = "xdis";
  version = "4.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ifakxxawyxw4w4p58m4xdc0c955miqyaq3dfbl386ipw0f50kyz";
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
