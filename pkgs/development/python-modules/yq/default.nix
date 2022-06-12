{ lib
, buildPythonPackage
, fetchPypi
, substituteAll
, argcomplete
, pyyaml
, toml
, xmltodict
, jq
, setuptools-scm
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "yq";
  version = "2.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-9L8rKZ0eXH69dM+yXR9dm2QBBjusB6LQmhVhRMHWROE=";
  };

  patches = [
    (substituteAll {
      src = ./jq-path.patch;
      jq = "${lib.getBin jq}/bin/jq";
    })
  ];

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pyyaml
    xmltodict
    toml
    argcomplete
  ];

  checkInputs = [
   pytestCheckHook
  ];

  pytestFlagsArray = [ "test/test.py" ];

  pythonImportsCheck = [ "yq" ];

  meta = with lib; {
    description = "Command-line YAML/XML/TOML processor - jq wrapper for YAML, XML, TOML documents";
    homepage = "https://github.com/kislyuk/yq";
    license = licenses.asl20;
    maintainers = with maintainers; [ womfoo SuperSandro2000 ];
  };
}
