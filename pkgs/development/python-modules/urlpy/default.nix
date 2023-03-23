{ lib
, fetchFromGitHub
, buildPythonPackage
, publicsuffix2
, pytestCheckHook
, pythonAtLeast
}:
buildPythonPackage rec {
  pname = "urlpy";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "urlpy";
    rev = "v${version}";
    sha256 = "962jLyx+/GS8wrDPzG2ONnHvtUG5Pqe6l1Z5ml63Cmg=";
  };

  dontConfigure = true;

  propagatedBuildInputs = [
    publicsuffix2
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.9") [
    # Fails with "AssertionError: assert 'unknown' == ''"
    "test_unknown_protocol"
  ];

  pythonImportsCheck = [
    "urlpy"
  ];

  meta = with lib; {
    description = "Simple URL parsing, canonicalization and equivalence";
    homepage = "https://github.com/nexB/urlpy";
    license = licenses.mit;
    maintainers = [ ];
  };
}
