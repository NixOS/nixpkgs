{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
  sphinxHook,
  sphinx-rtd-theme,
}:

buildPythonPackage rec {
  pname = "wrapt";
  version = "2.1.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GrahamDumpleton";
    repo = "wrapt";
    tag = version;
    hash = "sha256-9qXlljAcbV9pggqukPSskPge4YXujCrG0EFSXYHXKAw=";
  };

  build-system = [ setuptools ];

  nativeBuildInputs = [
    sphinxHook
    sphinx-rtd-theme
  ];

  outputs = [
    "out"
    "doc"
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "wrapt" ];

  meta = {
    description = "Module for decorators, wrappers and monkey patching";
    homepage = "https://github.com/GrahamDumpleton/wrapt";
    changelog = "https://github.com/GrahamDumpleton/wrapt/releases/tag/${src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
