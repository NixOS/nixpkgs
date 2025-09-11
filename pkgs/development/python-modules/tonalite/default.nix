{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:
buildPythonPackage rec {
  pname = "tonalite";
  version = "1.8.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KksZMmEF9G3W4BJ8HuluVcSvm7po0AGqzSV94lHg0Ls=";
  };

  build-system = [
    setuptools
  ];

  meta = {
    homepage = "https://github.com/Tiqets/tonalite";
    description = "Simple creation of data classes from dictionaries";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.gekoke ];
  };
}
