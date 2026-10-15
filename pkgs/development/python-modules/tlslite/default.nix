{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "tlslite";
  version = "0.4.9";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-m5pIdpTCOe/qjOxEVKmaVu4a4aXzrwhYzPgCnirC1C0=";
  };

  meta = {
    description = "Pure Python implementation of SSL and TLS";
    homepage = "https://pypi.org/project/tlslite/";
    license = lib.licenses.bsd3;
  };
}
