{ lib
, nixosTests
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
, toml
}:

buildPythonPackage rec {
  pname = "yq";
  version = "2.11.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q4rky0a6n4izmq7slb91a54g8swry1xrbfqxwc8lkd3hhvlxxkl";
  };

  postPatch = ''
    substituteInPlace test/test.py --replace "expect_exit_codes={0} if sys.stdin.isatty() else {2}" "expect_exit_codes={0}"
  '';

  propagatedBuildInputs = [
    pyyaml
    xmltodict
    argcomplete
  ];

  doCheck = true;

  checkInputs = [
   pytest
   coverage
   flake8
   pkgs.jq
   toml
  ];

  checkPhase = "pytest ./test/test.py";

  pythonImportsCheck = [ "yq" ];

  passthru.tests = { inherit (nixosTests) yq; };

  meta = with lib; {
    description = "Command-line YAML processor - jq wrapper for YAML documents";
    homepage = "https://github.com/kislyuk/yq";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
  };
}
