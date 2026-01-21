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
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GrahamDumpleton";
    repo = "wrapt";
    tag = version;
    hash = "sha256-AJGxQPWB7Yj37YysfaXNrWRbuLh1PUY+siwS4q5oSDw=";
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

  # not compatible with mypy 1.19.x
  disabledTestPaths = [ "tests/conftest.py" ];

  pythonImportsCheck = [ "wrapt" ];

  meta = {
    description = "Module for decorators, wrappers and monkey patching";
    homepage = "https://github.com/GrahamDumpleton/wrapt";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
