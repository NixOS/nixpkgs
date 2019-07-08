{ lib, buildPythonPackage, fetchPypi, requests, pytest, pytestcov, pytest-mock, pytest_xdist }:

buildPythonPackage rec {
  pname = "stripe";
  version = "2.30.0";

  # Tests require network connectivity and there's no easy way to disable
  # them. ~ C.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "de6be07c9e8a350d588278186316f66c72af7036aa5e917d1a924fb875249034";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytest pytestcov pytest-mock pytest_xdist ];

  meta = with lib; {
    description = "Stripe Python bindings";
    homepage = https://github.com/stripe/stripe-python;
    license = licenses.mit;
  };
}
