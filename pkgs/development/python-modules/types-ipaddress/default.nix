{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "types-ipaddress";
  version = "1.0.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-oD3zvlk15QugP6hD2qv/U5oEGijnPg/OLFcFvuVNOEE=";
  };

  pythonImportsCheck = [ "ipaddress-python2-stubs" ];

  meta = with lib; {
    description = "Typing stubs for ipaddress";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
