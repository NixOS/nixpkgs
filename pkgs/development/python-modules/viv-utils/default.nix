{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  funcy,
  intervaltree,
  pefile,
  pytest-sugar,
  pytestCheckHook,
  python-flirt,
  pythonOlder,
  setuptools-scm,
  typing-extensions,
  vivisect,
}:

buildPythonPackage rec {
  pname = "viv-utils";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "williballenthin";
    repo = "viv-utils";
    tag = "v${version}";
    hash = "sha256-tstuRdQPcx2tPC2r+ngS99Yi3oP33p+Z1rh3N6BUBgo=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    funcy
    intervaltree
    pefile
    typing-extensions
    vivisect
  ];

  nativeCheckInputs = [
    pytest-sugar
    pytestCheckHook
  ];

  passthru = {
    optional-dependencies = {
      flirt = [ python-flirt ];
    };
  };

  pythonImportsCheck = [ "viv_utils" ];

  meta = with lib; {
    description = "Utilities for working with vivisect";
    homepage = "https://github.com/williballenthin/viv-utils";
    changelog = "https://github.com/williballenthin/viv-utils/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = [ ];
  };
}
