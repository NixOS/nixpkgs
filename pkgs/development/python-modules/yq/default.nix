{ lib
, argcomplete
, buildPythonPackage
, fetchPypi
, jq
, pytestCheckHook
, pyyaml
, setuptools-scm
, substituteAll
, tomlkit
, xmltodict
}:

buildPythonPackage rec {
  pname = "yq";
  version = "3.2.3";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Kcj+HTa09kFj9NATFMauIXU5hw9hAhbe5gJd+16vr7E=";
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
    argcomplete
    pyyaml
    tomlkit
    xmltodict
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
