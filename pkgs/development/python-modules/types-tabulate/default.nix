{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "types-tabulate";
  version = "0.9.0.20241207";
  pyproject = true;

  src = fetchPypi {
    pname = "types_tabulate";
    inherit version;
    hash = "sha256-rBrBdHUMCjhd/SSO3GJ5+jKKr06jF5FauHmi7EeDMjA=";
  };

  build-system = [ setuptools ];

  # Module doesn't have tests
  doCheck = false;

  pythonImportsCheck = [ "tabulate-stubs" ];

  meta = with lib; {
    description = "Typing stubs for tabulate";
    homepage = "https://github.com/python/typeshed";
    license = licenses.asl20;
    maintainers = with maintainers; [ jpetrucciani ];
  };
}
