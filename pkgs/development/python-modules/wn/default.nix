{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  hatchling,
  httpx,
  tomli,

  starlette,

  pytestCheckHook,
  writableTmpDirAsHomeHook,
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

  optional-dependencies = {
    # doesn't exist in nixpkgs yet
    # editor = [
    #   wn-editor
    # ];

    web = [
      starlette
    ];
  };

  # probably not worth spending time on plus require additional dependencies
  disabledTestPaths = [ "bench/" ];

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
    pytestCheckHook
  ]
  ++ optional-dependencies.web;

  pythonImportsCheck = [ "wn" ];

  meta = with lib; {
    description = "Modern, interlingual wordnet interface for Python";
    homepage = "https://github.com/goodmami/wn";
    changelog = "https://github.com/goodmami/wn/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ zendo ];
  };
}
