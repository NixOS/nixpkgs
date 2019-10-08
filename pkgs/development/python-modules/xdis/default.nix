{ lib, buildPythonPackage, fetchFromGitHub
, click
, pytest
, six
}:

buildPythonPackage rec {
  pname = "xdis";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "python-xdis";
    rev = version;
    sha256 = "1m54d61ka9wgq0iqlzmsikzxa6qmwvnwsgm2kxb3vw5ic1psv4pv";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ six click ];

  checkPhase = ''
    make check
  '';

  meta = with lib; {
    description = "Python cross-version byte-code disassembler and marshal routines";
    homepage = https://github.com/rocky/python-xdis/;
    license = licenses.gpl2;
  };

}
