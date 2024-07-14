{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonAtLeast,
  ecdsa,
}:

buildPythonPackage rec {
  pname = "tlslite-ng";
  version = "0.7.6";
  format = "setuptools";

  # https://github.com/tlsfuzzer/tlslite-ng/issues/501
  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-arVvDpYpzj2AfrUoyREt76ny4AryspYSVOhCnKXB/wA=";
  };

  buildInputs = [ ecdsa ];

  meta = with lib; {
    description = "Pure python implementation of SSL and TLS";
    homepage = "https://pypi.python.org/pypi/tlslite-ng";
    license = licenses.lgpl2;
    maintainers = [ ];
  };
}
