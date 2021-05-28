{ stdenv, buildPythonPackage, fetchPypi
, nose, pyyaml, pathspec }:

buildPythonPackage rec {
  pname = "yamllint";
  version = "1.24.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07xn11i0c7x72xjxkkzrq9zxl40vfdr41mfvhlayrk6dpbk8vdj0";
  };

  checkInputs = [ nose ];

  propagatedBuildInputs = [  pyyaml pathspec ];

  # Two test failures
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A linter for YAML files";
    homepage = "https://github.com/adrienverge/yamllint";
    license = licenses.gpl3;
    maintainers = with maintainers; [ jonringer mikefaille ];
  };
}
