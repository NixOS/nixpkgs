{ stdenv, buildPythonPackage, fetchPypi
, nose, pyyaml, pathspec }:

buildPythonPackage rec {
  pname = "yamllint";
  version = "1.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "19fznzypkxgl1i9fy4d72xp7rbk30g62rjqmcmnqf3ij46p8flj2";
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
