{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-ipaddress";
  version = "1.0.8";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0h9q9pjvw1ap5k70ygp750d096jkzymxlhx87yh0pr9mb6zg6gd0";
  };

  build-system = [ setuptools ];

  pythonImportsCheck = [ "ipaddress-python2-stubs" ];

  meta = {
    description = "Typing stubs for ipaddress";
    homepage = "https://github.com/python/typeshed";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jpetrucciani ];
  };
}
