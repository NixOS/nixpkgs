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

  # Disable strict runtime dependency checking until upstream relaxes
  # exact version pin on requests (requests==2.32.4 -> requests>=2.32.4)
  # See: https://github.com/sbrunner/sphinx-prompt/pull/609
  # See: https://github.com/NixOS/nixpkgs/issues/449603
  dontCheckRuntimeDeps = true;

  meta = with lib; {
    description = "Sphinx extension for creating unselectable prompt";
    homepage = "https://github.com/sbrunner/sphinx-prompt";
    license = licenses.bsd3;
    maintainers = with maintainers; [ kaction ];
  };
}
