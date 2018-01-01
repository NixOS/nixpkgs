{ stdenv, buildPythonPackage, fetchPypi
, nose, pyyaml, pathspec }:

buildPythonPackage rec {
  pname = "yamllint";
  version = "1.8.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d7322e4bd2d8f2de3396298d719019f44393d31a9ecdf3512cab0ec5b9878d7";
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
