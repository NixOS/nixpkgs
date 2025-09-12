{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  webencodings,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "tinyhtml5";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "CourtBouillon";
    repo = "tinyhtml5";
    tag = version;
    hash = "sha256-8OKZAQyFMoICcln6XxTE9MHivXaW8pBVC6n+hbriIoU=";
  };

  build-system = [
    flit-core
  ];

  dependencies = [
    webencodings
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "tinyhtml5"
  ];

  meta = {
    changelog = "https://github.com/CourtBouillon/tinyhtml5/releases/tag/${src.tag}";
    description = "Tiny HTML5 parser";
    homepage = "https://github.com/CourtBouillon/tinyhtml5";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
  };
}
