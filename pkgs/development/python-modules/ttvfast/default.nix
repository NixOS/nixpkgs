{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  numpy,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "ttvfast";
  version = "0.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "mindriot101";
    repo = "ttvfast-python";
    tag = "v${finalAttrs.version}";
    # The TTVFast C sources are vendored as a git submodule
    fetchSubmodules = true;
    hash = "sha256-8uRJnqNgXBKAnJUEe1subsQktNkUnREWD4LuG873osE=";
  };

  # Drop the python2-compat `six` import (only used in the tests)
  postPatch = ''
    substituteInPlace testing/test_ttvfast.py \
      --replace-fail "from six.moves import range" ""
  '';

  build-system = [ setuptools ];

  pythonImportsCheck = [ "ttvfast" ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  # Import the installed package (with the compiled extension), not the source tree
  preCheck = ''
    rm -rf ttvfast
  '';

  enabledTestPaths = [ "testing" ];

  meta = {
    description = "Python wrapper for the TTVFast transit timing variation code";
    homepage = "https://github.com/mindriot101/ttvfast-python";
    changelog = "https://github.com/mindriot101/ttvfast-python/blob/${finalAttrs.src.rev}/CHANGELOG.rst";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
