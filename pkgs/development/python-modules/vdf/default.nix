{ stdenv, buildPythonPackage, fetchFromGitHub
, pytest, pytestcov, mock }:

buildPythonPackage rec {
  pname = "vdf";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "ValvePython";
    repo = pname;
    rev = "v${version}";
    sha256 = "08rb982hcwc9pr9gl0zfk9266h84fwbz097qjfkss3srwghr1247";
  };

  checkInputs = [ pytest pytestcov mock ];
  checkPhase = "make test";

  meta = with stdenv.lib; {
    description = "Library for working with Valve's VDF text format";
    homepage = https://github.com/ValvePython/vdf;
    license = licenses.mit;
    maintainers = with maintainers; [ metadark ];
  };
}
