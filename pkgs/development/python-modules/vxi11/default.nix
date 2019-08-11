{ stdenv, buildPythonPackage, fetchFromGitHub, nose }:

buildPythonPackage rec {
  pname = "python-vxi11";
  version = "0.9";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "python-ivi";
    repo = pname;
    rev = "v${version}";
    sha256 = "1xv7chp7rm0vrvbz6q57fpwhlgjz461h08q9zgmkcl2l0w96hmsn";
  };

  checkInputs = [ nose ];
  checkPhase = ''
    nosetests
  '';

  meta = with stdenv.lib; {
    description = "VXI-11 driver for controlling instruments over Ethernet";
    homepage = https://github.com/python-ivi/python-vxi11;
    license = licenses.mit;
    maintainers = with maintainers; [ bgamari ];
  };
}
