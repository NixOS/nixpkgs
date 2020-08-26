{ lib, buildPythonPackage, fetchPypi, requests, pytest, pytestcov, pytest-mock, pytest_xdist }:

buildPythonPackage rec {
  pname = "stripe";
  version = "2.49.0";

  # Tests require network connectivity and there's no easy way to disable
  # them. ~ C.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "10dgll0x709n91p8m9qmifsdhx2sc2920xxhqzd335l4z20iwcw9";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytest pytestcov pytest-mock pytest_xdist ];

  meta = with lib; {
    description = "Stripe Python bindings";
    homepage = "https://github.com/stripe/stripe-python";
    license = licenses.mit;
  };
}
