{ stdenv, buildPythonPackage, fetchPypi
, unittest2, mock, requests }:

buildPythonPackage rec {
  pname = "stripe";
  version = "1.79.0";
  name = "${pname}-${version}";

  # Tests require network connectivity and there's no easy way to disable
  # them. ~ C.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "490bb7bfc7d224e483d643171fd860f8a1670e31fd9cef8cb8d9a7c19806d450";
  };

  buildInputs = [ unittest2 mock ];

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "Stripe Python bindings";
    homepage = https://github.com/stripe/stripe-python;
    license = licenses.mit;
  };
}
