{
  lib,
  buildPythonPackage,
  fetchPypi,
  twisted,
  requests,
  cryptography,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "txrequests";
  version = "0.9.6";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b452a1cafa4d005678f6fa47922a330feb4907d5b4732d1841ca98e89f1362e1";
  };

  propagatedBuildInputs = [
    twisted
    requests
    cryptography
  ];

  # Require network access
  doCheck = false;

  nativeCheckInputs = [ unittestCheckHook ];

  meta = with lib; {
    description = "Asynchronous Python HTTP for Humans";
    homepage = "https://github.com/tardyp/txrequests";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
  };
}
