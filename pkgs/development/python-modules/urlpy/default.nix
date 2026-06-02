{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  publicsuffix2,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "urlpy";
  version = "0.5.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "nexB";
    repo = "urlpy";
    rev = "v${version}";
    sha256 = "962jLyx+/GS8wrDPzG2ONnHvtUG5Pqe6l1Z5ml63Cmg=";
  };

  dontConfigure = true;

  propagatedBuildInputs = [ publicsuffix2 ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # Fails with "AssertionError: assert 'unknown' == ''"
    "test_unknown_protocol"
  ];

  pythonImportsCheck = [ "urlpy" ];

  meta = {
    description = "Simple URL parsing, canonicalization and equivalence";
    homepage = "https://github.com/nexB/urlpy";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
