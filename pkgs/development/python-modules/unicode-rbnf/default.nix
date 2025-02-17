{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "unicode-rbnf";
  version = "2.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "unicode-rbnf";
    tag = "v${version}";
    hash = "sha256-jVooLqy1FjCQGll53DqQ074ypjGwPRBzVmgEYXtMP+Y=";
  };

  nativeBuildInputs = [ setuptools ];

  pythonImportsCheck = [ "unicode_rbnf" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    changelog = "https://github.com/rhasspy/unicode-rbnf/blob/v${version}/CHANGELOG.md";
    description = "Pure Python implementation of ICU's rule-based number format engine";
    homepage = "https://github.com/rhasspy/unicode-rbnf";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
