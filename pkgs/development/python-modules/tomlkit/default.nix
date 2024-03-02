{ lib
, buildPythonPackage
, fetchPypi

# build-system
, poetry-core

# tests
, pytestCheckHook
, pyyaml
}:

buildPythonPackage rec {
  pname = "tomlkit";
  version = "0.12.3";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dbr1AS0GUB8HvuW/joAbnzQ+eqxaklgfIPgM5jLmtaQ=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  nativeCheckInputs = [
    pyyaml
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tomlkit" ];

  meta = with lib; {
    homepage = "https://github.com/sdispater/tomlkit";
    changelog = "https://github.com/sdispater/tomlkit/blob/${version}/CHANGELOG.md";
    description = "Style-preserving TOML library for Python";
    license = licenses.mit;
    maintainers = with maintainers; [ jakewaksbaum ];
  };
}
