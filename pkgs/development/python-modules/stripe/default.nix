{ stdenv, buildPythonPackage, fetchPypi
, unittest2, mock, requests }:

buildPythonPackage rec {
  pname = "stripe";
  version = "1.70.0";
  name = "${pname}-${version}";

  # Tests require network connectivity and there's no easy way to disable
  # them. ~ C.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ee77103d2d18fe6369f23c40c93067425c5ed67e08b1a7678e681217e8fa8062";
  };

  buildInputs = [ unittest2 mock ];

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "Stripe Python bindings";
    homepage = https://github.com/stripe/stripe-python;
    license = licenses.mit;
  };
}
