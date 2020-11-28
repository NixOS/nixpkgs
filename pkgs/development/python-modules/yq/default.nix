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
  version = "2.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q4rky0a6n4izmq7slb91a54g8swry1xrbfqxwc8lkd3hhvlxxkl";
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
    description = "Command-line YAML processor - jq wrapper for YAML documents";
    homepage = "https://github.com/kislyuk/yq";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
  };
}
