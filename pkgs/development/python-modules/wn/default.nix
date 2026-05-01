{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pytest-benchmark,
  hatchling,
  httpx,
  tomli,
  starlette,
}:

buildPythonPackage rec {
  pname = "wn";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Cdc8EEkVvLvFidrppyIgSClcg96zL8MYpitSEX8NUDw=";
  };

  build-system = [ hatchling ];

  dependencies = [
    httpx
    tomli
  ];

  optional-dependencies.web = [
    starlette
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-benchmark
  ]
  ++ optional-dependencies.web;

  pytestFlags = [ "--benchmark-disable" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pythonImportsCheck = [ "wn" ];

  meta = {
    description = "Modern, interlingual wordnet interface for Python";
    homepage = "https://github.com/goodmami/wn";
    changelog = "https://github.com/goodmami/wn/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ zendo ];
  };
}
