{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sybil";
  version = "4.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "simplistix";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-NvgmAFRuiBbyPnJykQlYNyQYALx1bFubMrakw671fDY=";
  };

  # Circular dependency with testfixtures
  doCheck = false;

  pythonImportsCheck = [
    "sybil"
  ];

  meta = with lib; {
    description = "Automated testing for the examples in your documentation";
    homepage = "https://github.com/cjw296/sybil";
    changelog = "https://github.com/simplistix/sybil/blob/${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
