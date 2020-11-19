{ lib, buildPythonPackage, fetchPypi, requests, pytest, pytestcov, pytest-mock, pytest_xdist }:

buildPythonPackage rec {
  pname = "stripe";
  version = "2.54.0";

  # Tests require network connectivity and there's no easy way to disable
  # them. ~ C.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a622bce0d6d0ac99a53b6e6a6475c39250207d644f28ad0ed276af7b96d12617";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytest pytestcov pytest-mock pytest_xdist ];

  meta = with lib; {
    description = "Stripe Python bindings";
    homepage = "https://github.com/stripe/stripe-python";
    license = licenses.mit;
  };
}
