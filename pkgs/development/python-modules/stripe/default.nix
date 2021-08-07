{ lib, buildPythonPackage, fetchPypi, requests, pytest, pytest-cov, pytest-mock, pytest-xdist }:

buildPythonPackage rec {
  pname = "stripe";
  version = "2.58.0";

  # Tests require network connectivity and there's no easy way to disable
  # them. ~ C.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "34829b528e652ffc919d40eff2ba78021149818bab76e33c07801382921cf6d5";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytest pytest-cov pytest-mock pytest-xdist ];

  meta = with lib; {
    description = "Stripe Python bindings";
    homepage = "https://github.com/stripe/stripe-python";
    license = licenses.mit;
  };
}
