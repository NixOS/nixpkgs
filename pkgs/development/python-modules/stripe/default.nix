{ lib, buildPythonPackage, fetchPypi, requests, toml, pytest, pytestcov, pytest-mock, pytest_xdist }:

buildPythonPackage rec {
  pname = "stripe";
  version = "2.29.3";

  # Tests require network connectivity and there's no easy way to disable
  # them. ~ C.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "73f9af72ef8125e0d1c713177d006f1cbe95602beb3e10cb0b0a4ae358d1ae86";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "toml>=0.9,<0.10" "toml>=0.9"
  '';

  propagatedBuildInputs = [ toml requests ];

  checkInputs = [ pytest pytestcov pytest-mock pytest_xdist ];

  meta = with lib; {
    description = "Stripe Python bindings";
    homepage = https://github.com/stripe/stripe-python;
    license = licenses.mit;
  };
}
