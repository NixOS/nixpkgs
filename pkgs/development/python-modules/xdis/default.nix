{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, click
, pytest
, six
}:

buildPythonPackage rec {
  pname = "xdis";
  version = "4.2.4";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "python-xdis";
    rev = version;
    sha256 = "0nq6ijmj48c2dk75vmb040wgvr4y7wyjxrcm2dyvcwfk2h6phwri";
  };

  checkInputs = [ pytest ];
  propagatedBuildInputs = [ six click ];

  checkPhase = ''
    make check
  '';

  meta = with lib; {
    description = "Python cross-version byte-code disassembler and marshal routines";
    homepage = "https://github.com/rocky/python-xdis/";
    license = licenses.gpl2;
  };
}
