{ lib, buildPythonPackage, fetchPypi, isPy3k
, unittest2, mock, requests, simplejson }:

buildPythonPackage rec {
  pname = "stripe";
  version = "2.11.0";

  # Tests require network connectivity and there's no easy way to disable
  # them. ~ C.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "4daf25e0182ad7d75f118b5b550c8c7f55f6af88a833f8c1914c1cbd062c6633";
  };

  checkInputs = [ unittest2 mock ];

  propagatedBuildInputs = [ requests ] ++ lib.optional (!isPy3k) simplejson;

  meta = with lib; {
    description = "Stripe Python bindings";
    homepage = https://github.com/stripe/stripe-python;
    license = licenses.mit;
  };
}
