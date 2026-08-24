{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-mock";
  version = "5.2.0.20260518";
  pyproject = true;

  src = fetchPypi {
    pname = "types_mock";
    inherit version;
    hash = "sha256-Sa+cGKrEyqkODh6EN+IWDNiz8SYFPa5kU9ZbOTWQ/Pk=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  meta = {
    description = "Type stub package for the mock package";
    homepage = "https://pypi.org/project/types-mock";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}
