{
  lib,
  argcomplete,
  buildPythonPackage,
  fetchPypi,
  jq,
  pytestCheckHook,
  pyyaml,
  setuptools,
  setuptools-scm,
  replaceVars,
  tomlkit,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "yq";
  version = "3.4.3";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ulhqGm8wz3BbL5IgZxLfIoHNMgKAIQ57e4Cty48lbjs=";
  };

  patches = [
    (replaceVars ./jq-path.patch {
      jq = "${lib.getBin jq}/bin/jq";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    argcomplete
    pyyaml
    tomlkit
    xmltodict
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "test/test.py" ];

  pythonImportsCheck = [ "yq" ];

  meta = with lib; {
    description = "Command-line YAML/XML/TOML processor - jq wrapper for YAML, XML, TOML documents";
    homepage = "https://github.com/kislyuk/yq";
    license = licenses.asl20;
    maintainers = with maintainers; [
      SuperSandro2000
    ];
    mainProgram = "yq";
  };
}
