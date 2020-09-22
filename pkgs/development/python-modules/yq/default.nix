{ lib
, buildPythonPackage
, fetchPypi
, pkgs
, argcomplete
, pyyaml
, xmltodict
# Test inputs
, coverage
, flake8
, jq
, pytest
, unixtools
, toml
}:

buildPythonPackage rec {
  pname = "yq";
  version = "2.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1gp9q5w1bjbw7wmba5hm8ippwvkind0p02n07fqa9jlqglhxhm46";
  };

  propagatedBuildInputs = [
    pyyaml
    xmltodict
    argcomplete
  ];

  doCheck = true;

  checkInputs = [
   unixtools.script
   pytest
   coverage
   flake8
   pkgs.jq
   toml
  ];

  # tests fails if stdin is not a tty
  checkPhase = "echo | script -c 'pytest ./test/test.py'";

  pythonImportsCheck = [ "yq" ];

  meta = with lib; {
    description = "Command-line YAML processor - jq wrapper for YAML documents.";
    homepage = "https://github.com/kislyuk/yq";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
  };
}
