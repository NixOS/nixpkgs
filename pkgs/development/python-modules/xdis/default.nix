{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, click
, pytest
, six
}:

buildPythonPackage rec {
  pname = "xdis";
  version = "4.1.2";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rocky";
    repo = "python-xdis";
    rev = version;
    sha256 = "0icqhafsnmcs6628cg3jjgq0d3x835nqmhljcz93yi457hfqd2lp";
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
