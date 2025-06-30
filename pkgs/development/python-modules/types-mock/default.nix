{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-mock";
  version = "5.2.0.20250516";
  pyproject = true;

  src = fetchPypi {
    pname = "types_mock";
    inherit version;
    hash = "sha256-qrfT2a04FPL42hLMjkLZvn04IAxfIU48AnjDj6ASmdc=";
  };

  build-system = [ setuptools ];

  # Module has no tests
  doCheck = false;

  meta = with lib; {
    description = "Type stub package for the mock package";
    homepage = "https://pypi.org/project/types-mock";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
