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
    hash = "sha256-tFKhyvpNAFZ49vpHkiozD+tJB9W0cy0YQcqY6J8TYuE=";
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
