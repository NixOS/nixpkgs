{ stdenv, buildPythonPackage, fetchFromGitHub
, pytest, pytestcov, mock }:

buildPythonPackage rec {
  pname = "vdf";
  version = "3.1";

  src = fetchFromGitHub {
    owner = "ValvePython";
    repo = pname;
    rev = "v${version}";
    sha256 = "19xqjq2159w2l9vaxlkickvy3zksp9ssdkvbfcfggxz31miwp1zr";
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
