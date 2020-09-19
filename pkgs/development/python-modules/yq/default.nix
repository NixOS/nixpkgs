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
, toml
}:

buildPythonPackage rec {
  pname = "yq";
  version = "2.10.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h6nnkp53mm4spwy8nyxwvh9j6p4lxvf20j4bgjskhnhaw3jl9gn";
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

  meta = with lib; {
    description = "Command-line YAML processor - jq wrapper for YAML documents.";
    homepage = "https://github.com/kislyuk/yq";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
  };
}
