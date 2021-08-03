{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pytestCheckHook
, pytest-cov
, jinja2
, pyyaml
}:

buildPythonPackage rec {
  pname = "typesystem";
  version = "0.2.4";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "1k0jwcky17zwaz2vx4x2zbsnp270g4mgn7kx5bpl8jgx76qmsnba";
  };

  propagatedBuildInputs = [
    jinja2
    pyyaml
  ];

  checkInputs = [
    pytestCheckHook
    pytest-cov
  ];

  disabledTests = [
    # https://github.com/encode/typesystem/issues/102. cosmetic issue where python3.8 changed
    # the default string formatting of regular expression flags which breaks test assertion
    "test_to_json_schema_complex_regular_expression"
  ];
  disabledTestPaths = [
    # for some reason jinja2 not picking up forms directory (1% of tests)
    "tests/test_forms.py"
  ];

  meta = with lib; {
    description = "A type system library for Python";
    homepage = "https://github.com/encode/typesystem";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
