{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pytest-benchmark,
  pythonOlder,
  hatchling,
  httpx,
  tomli,
  starlette,
}:

buildPythonPackage rec {
  pname = "wn";
  version = "0.14.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-z2mDEFx7Qn5LKyji4CgFhxvCUblZeXLf2hjy4i6lMjQ=";
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

  meta = with lib; {
    description = "Modern, interlingual wordnet interface for Python";
    homepage = "https://github.com/goodmami/wn";
    changelog = "https://github.com/goodmami/wn/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
