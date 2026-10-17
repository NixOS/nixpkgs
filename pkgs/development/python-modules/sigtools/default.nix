{
  lib,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  mock,
  pytestCheckHook,
  repeated-test,
  setuptools-scm,
  sphinx,
}:
buildPythonPackage (finalAttrs: {
  pname = "sigtools";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "epsy";
    repo = "sigtools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-q5Bzc6fgDJCqt0SA/C/mg2fbUFyXLcsRU+tSl8FdZdI=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [ attrs ];

  nativeCheckInputs = [
    mock
    pytestCheckHook
    repeated-test
    sphinx
  ];

  disabledTestPaths = [
    # Tests are out-dated
    "sigtools/tests/test_forwards.py"
    "sigtools/tests/test_mask.py"
    "sigtools/tests/test_merge.py"
    "sigtools/tests/test_autoforwards_pep563.py"
    "sigtools/tests/test_embed.py"
  ];

  disabledTests = [
    # NameError: name 'o' is not defined
    "test_locals"
  ];

  pythonImportsCheck = [ "sigtools" ];

  meta = {
    description = "Utilities for working with inspect.Signature objects";
    homepage = "https://sigtools.readthedocs.io/";
    changelog = "https://github.com/epsy/sigtools/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
