{ stdenv, buildPythonPackage, fetchFromGitHub
, pytest, pytestcov, mock }:

buildPythonPackage rec {
  pname = "vdf";
  version = "3.3";

  src = fetchFromGitHub {
    owner = "ValvePython";
    repo = pname;
    rev = "v${version}";
    sha256 = "0d9bhxdznry7kzyma00cxwjn6rqnd6vw8v5ym68k6qswgfzb569i";
  };

  checkInputs = [ pytest pytestcov mock ];
  checkPhase = "make test";

  meta = with stdenv.lib; {
    description = "Library for working with Valve's VDF text format";
    homepage = "https://github.com/ValvePython/vdf";
    license = licenses.mit;
    maintainers = with maintainers; [ metadark ];
  };
}
