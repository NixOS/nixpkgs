{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nh3,
  pillow,
  pytest-cov-stub,
  pytestCheckHook,
  regex,
  setuptools-scm,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "textile";
  version = "4.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "textile";
    repo = "python-textile";
    tag = finalAttrs.version;
    hash = "sha256-wbR/IGbJkoGk1E6ymEhmqR3GUMymLPExnclYOP39yts=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    nh3
    regex
  ];

  optional-dependencies = {
    imagesize = [ pillow ];
  };

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "textile" ];

  meta = {
    description = "Module for generating web text";
    homepage = "https://github.com/textile/python-textile";
    changelog = "https://github.com/textile/python-textile/blob/${finalAttrs.src.tag}/CHANGELOG.textile";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "pytextile";
  };
})
