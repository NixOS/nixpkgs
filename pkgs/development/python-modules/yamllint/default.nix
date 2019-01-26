{ stdenv, buildPythonPackage, fetchPypi
, nose, pyyaml, pathspec }:

buildPythonPackage rec {
  pname = "yamllint";
  version = "1.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0x9ansmhqvc3rj0nbhpl0jdqr5pk6qdxf7i6r4gr0hzqr50vdaf0";
  };

  checkInputs = [ nose ];

  propagatedBuildInputs = [  pyyaml pathspec ];

  # Two test failures
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A linter for YAML files";
    homepage = https://github.com/adrienverge/yamllint;
    license = licenses.gpl3;
    maintainers = with maintainers; [ mikefaille ];
  };
}
