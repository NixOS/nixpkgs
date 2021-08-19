{ lib, buildPythonPackage, fetchPypi, requests, pytest, pytest-cov, pytest-mock, pytest-xdist }:

buildPythonPackage rec {
  pname = "stripe";
  version = "2.60.0";

  # Tests require network connectivity and there's no easy way to disable
  # them. ~ C.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "8966b7793014380f60c6f121ba333d6f333a55818edaf79c8d70464ce0a7a808";
  };

  propagatedBuildInputs = [ requests ];

  checkInputs = [ pytest pytest-cov pytest-mock pytest-xdist ];

  meta = with lib; {
    description = "Stripe Python bindings";
    homepage = "https://github.com/stripe/stripe-python";
    license = licenses.mit;
  };
}
