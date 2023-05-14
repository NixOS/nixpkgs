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
  version = "3.1.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-hT80KxVi3e6XkDjsjs7lQFzdm2p8uB7WzbgBjJ6AJjM=";
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

  nativeCheckInputs = [
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
