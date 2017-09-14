{ stdenv, buildPythonPackage, fetchPypi
, unittest2, mock, requests }:

buildPythonPackage rec {
  pname = "stripe";
  version = "1.62.1";
  name = "${pname}-${version}";

  # Tests require network connectivity and there's no easy way to disable
  # them. ~ C.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7cc83b8d405a48d8a792640761519c64e373ad3514ea8bb4a9a5128f98b0b679";
  };

  buildInputs = [ unittest2 mock ];

  propagatedBuildInputs = [ requests ];

  meta = with stdenv.lib; {
    description = "Stripe Python bindings";
    homepage = https://github.com/stripe/stripe-python;
    license = licenses.mit;
  };
}
