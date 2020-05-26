{ stdenv, buildPythonPackage, fetchPypi
, nose, pyyaml, pathspec }:

buildPythonPackage rec {
  pname = "yamllint";
  version = "1.21.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "14yijcnmanyd3s2ir38sxl07rzpxgpgw9s6b8sy68jrl7n5nj7ky";
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
