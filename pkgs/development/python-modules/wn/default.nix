{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
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
  version = "0.13.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "goodmami";
    repo = "wn";
    tag = "v${version}";
    hash = "sha256-xUraVRQmr4Oq1T/RiWgch8YJtAZR9ebOzaGBJ1NPKtw=";
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
    changelog = "https://github.com/goodmami/wn/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
