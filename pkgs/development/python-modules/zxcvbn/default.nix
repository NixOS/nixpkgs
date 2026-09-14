{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "zxcvbn";
  version = "4.5.0";
  pyproject = true;

  __structuredAttrs = true;

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "dwolfhub";
    repo = "zxcvbn-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0SVJkJMEMnZVMpamDVP02kMwWRSj5zGlrMYG9kn0aXQ=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "zxcvbn" ];

  meta = {
    description = "Python implementation of Dropbox's realistic password strength estimator";
    mainProgram = "zxcvbn";
    homepage = "https://github.com/dwolfhub/zxcvbn-python";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
