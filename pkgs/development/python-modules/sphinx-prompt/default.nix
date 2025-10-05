{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,
  poetry-dynamic-versioning,

  # dependencies
  docutils,
  pygments,
  sphinx,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "sphinx-prompt";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sbrunner";
    repo = "sphinx-prompt";
    tag = version;
    hash = "sha256-JKCTn2YkdyGLvchMT9C61PxjYxuQFzt3SjCE9JvgtVc=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    docutils
    pygments
    sphinx
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Sphinx extension for creating unselectable prompt";
    homepage = "https://github.com/sbrunner/sphinx-prompt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kaction ];
  };
}
