{ lib
, buildPythonPackage
, fetchPypi
, pbr
, fixtures, testtools
}:

buildPythonPackage rec {
  pname = "testresources";
  version = "2.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05s4dsli9g17m1r3b1gvwicbbgq011hnpb2b9qnj27ja2n11k7gf";
  };

  propagatedBuildInputs = [
    pbr
  ];

  checkInputs = [ fixtures testtools ];

  meta = with lib;{
    description = "Pyunit extension for managing expensive test resources";
    homepage = https://pypi.python.org/pypi/testresources/;
    license = licenses.bsd2;
  };

}
