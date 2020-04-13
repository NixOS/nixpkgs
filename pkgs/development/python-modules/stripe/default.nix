{ lib, buildPythonPackage, fetchPypi, requests, pytest, pytestcov, pytest-mock, pytest_xdist }:

buildPythonPackage rec {
  pname = "stripe";
  version = "2.44.0";

  # Tests require network connectivity and there's no easy way to disable
  # them. ~ C.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0aaaf8dp989im2n0cdmslq0ys4ia970yl1irhxiwwqarmh6fap5i";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytest pytestcov pytest-mock pytest_xdist ];

  meta = with lib; {
    description = "Stripe Python bindings";
    homepage = "https://github.com/stripe/stripe-python";
    license = licenses.mit;
  };
}
