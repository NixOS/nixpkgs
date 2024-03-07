{ lib
, buildPythonPackage
, fetchFromGitHub

# build-system
, setuptools

# tests
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "unicode-rbnf";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rhasspy";
    repo = "unicode-rbnf";
    rev = "v${version}";
    hash = "sha256-xwnfqWwQJKCJ4G+8eVaySTJAHxhwKYAqLHaCsxtBIl0=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  pythonImportsCheck = [
    "unicode_rbnf"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/rhasspy/unicode-rbnf/v${version}/master/CHANGELOG.md";
    description = "A pure Python implementation of ICU's rule-based number format engine";
    homepage = "https://github.com/rhasspy/unicode-rbnf";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
