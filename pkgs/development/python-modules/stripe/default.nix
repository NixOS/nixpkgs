{ lib, buildPythonPackage, fetchPypi, isPy3k
, unittest2, mock, requests, simplejson }:

buildPythonPackage rec {
  pname = "stripe";
  version = "1.79.0";

  # Tests require network connectivity and there's no easy way to disable
  # them. ~ C.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "490bb7bfc7d224e483d643171fd860f8a1670e31fd9cef8cb8d9a7c19806d450";
  };

  checkInputs = [ unittest2 mock ];

  propagatedBuildInputs = [ requests ] ++ lib.optional (!isPy3k) simplejson;

  meta = with lib; {
    description = "Stripe Python bindings";
    homepage = https://github.com/stripe/stripe-python;
    license = licenses.mit;
  };
}
