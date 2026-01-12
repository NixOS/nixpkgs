{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "types-urllib3";
  version = "1.26.25.14";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ipt/V3yVG4wbksG8Ky/bC0mEe9KvbRzCouPdNA872o8=";
  };

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "urllib3-stubs" ];

  meta = {
    description = "Typing stubs for urllib3";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
