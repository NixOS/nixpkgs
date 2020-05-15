{ stdenv, buildPythonPackage, fetchPypi
, nose, pyyaml, pathspec }:

buildPythonPackage rec {
  pname = "yamllint";
  version = "1.23.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1agl80csxhiqglm0idwhw98iqfpp61c9inzcdaz4czsfyivzzwsr";
  };

  checkInputs = [ nose ];

  propagatedBuildInputs = [  pyyaml pathspec ];

  # Two test failures
  doCheck = false;

  meta = with stdenv.lib; {
    description = "A linter for YAML files";
    homepage = "https://github.com/adrienverge/yamllint";
    license = licenses.gpl3;
    maintainers = with maintainers; [ mikefaille ];
  };
}
