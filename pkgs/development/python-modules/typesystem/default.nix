{ lib
, buildPythonPackage
, fetchFromGitHub
, isPy27
, pytest
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
    pytest
    pytestcov
  ];

  # for some reason jinja2 not picking up forms directory (1% of tests)
  checkPhase = ''
    pytest --ignore=tests/test_forms.py
  '';

  meta = with lib; {
    description = "A type system library for Python";
    homepage = https://github.com/encode/typesystem;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
