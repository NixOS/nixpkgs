{ lib
, nixosTests
, buildPythonPackage
, fetchPypi
, substituteAll
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
  version = "2.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-HSrUA1BNMGtSWLhsaY+YVtetWLe7F6K4dWkaanuMTCA=";
  };

  patches = [
    (substituteAll {
      src = ./jq-path.patch;
      jq = "${lib.getBin pkgs.jq}/bin/jq";
    })
  ];

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
