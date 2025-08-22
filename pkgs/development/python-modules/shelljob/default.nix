{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "shelljob";
  version = "0.6.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mortoray";
    repo = "shelljob";
    tag = "v${version}";
    hash = "sha256-UJ8DcQaYUiZMZ4hh2juQ/HUwY4LtH6GDjZWioNnfBmw=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "shelljob" ];

  disabledTests = [
    "test_basic"
    "test_unicode_group"
    "test_example"
    "test_encoding"
  ];

  meta = {
    description = "Python process and file system module";
    homepage = "https://github.com/mortoray/shelljob";
    changelog = "https://github.com/mortoray/shelljob/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felbinger ];
  };
}
