{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pytestCheckHook
, pytestcov
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
    pytestcov
  ];

  disabledTests = [ "test_to_json_schema_complex_regular_expression" ];

  meta = with lib; {
    description = "A type system library for Python";
    homepage = "https://github.com/encode/typesystem";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
