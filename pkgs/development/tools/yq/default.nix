{ lib
, buildPythonApplication
, fetchPypi
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

buildPythonApplication rec {
  pname = "yq";
  version = "2.10.1";

  propagatedBuildInputs = [ pyyaml xmltodict jq argcomplete ];

  doCheck = true;

  checkInputs = [
   pytest
   coverage
   flake8
   jq
   toml
  ];

  checkPhase = "pytest ./test/test.py";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h6nnkp53mm4spwy8nyxwvh9j6p4lxvf20j4bgjskhnhaw3jl9gn";
  };

  meta = with lib; {
    description = "Command-line YAML processor - jq wrapper for YAML documents.";
    homepage = "https://github.com/kislyuk/yq";
    license = [ licenses.asl20 ];
    maintainers = [ maintainers.womfoo ];
  };
}
