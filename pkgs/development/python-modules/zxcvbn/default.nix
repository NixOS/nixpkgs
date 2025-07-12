{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "zxcvbn";
  version = "4.5.0";
  format = "setuptools";

  # no tests included in PyPI tarball
  src = fetchFromGitHub {
    owner = "dwolfhub";
    repo = "zxcvbn-python";
    tag = "v${version}";
    hash = "sha256-0SVJkJMEMnZVMpamDVP02kMwWRSj5zGlrMYG9kn0aXQ=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Python implementation of Dropbox's realistic password strength estimator";
    mainProgram = "zxcvbn";
    homepage = "https://github.com/dwolfhub/zxcvbn-python";
    license = licenses.mit;
    maintainers = [ ];
  };
}
