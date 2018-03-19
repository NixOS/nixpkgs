{ stdenv, buildPythonPackage, fetchPypi, nose }:

buildPythonPackage rec {
  pname = "python-vxi11";
  version = "0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zvd0wxp6mccaxy9fzlzk3i4pr2ggnj79r3awimjqd89pvaxiyq1";
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
