{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  cachetools,
  pandas,
  requests,
  pytest,
  pytest-cov,
}:

buildPythonPackage rec {
  pname = "world-bank-data";
  version = "0.1.4";
  pyproject = true;

  src = fetchPypi {
    pname = "world_bank_data";
    inherit version;
    hash = "sha256-UidtJovurzrZKWeI7n1bV0vluc5pSg92zKFELvZE9fw=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    cachetools
    pandas
    requests
  ];

  optional-dependencies = {
    test = [
      pytest
      pytest-cov
    ];
  };

  pythonImportsCheck = [
    "world_bank_data"
  ];

  meta = {
    description = "World Bank Data API in Python";
    homepage = "https://pypi.org/project/world-bank-data";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
