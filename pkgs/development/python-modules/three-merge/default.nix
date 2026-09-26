{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  diff-match-patch,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "three-merge";
  version = "0.1.1";
  pyproject = true;

  __structuredAttrs = true;

  # pypi does not contain test files
  src = fetchFromGitHub {
    owner = "spyder-ide";
    repo = "three-merge";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BtWgBOSddLB7mQoc8vhGKxBBkdnvyASyrwRLA7lGgrs=";
  };

  build-system = [ setuptools ];

  dependencies = [ diff-match-patch ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "three_merge" ];

  meta = {
    description = "Simple library for merging two strings with respect to a base one";
    homepage = "https://github.com/spyder-ide/three-merge";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
