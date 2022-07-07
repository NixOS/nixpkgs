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
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5H/yR5o3RvkL27d/hOPr23ic5GoJKxwmGuWx9fkU+Og=";
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
