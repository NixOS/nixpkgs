{
  lib,
  buildPythonPackage,
  dpath,
  fetchFromGitHub,
  numpy,
  plac,
  poetry-core,
  pytestCheckHook,
  pythonOlder,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "yte";
  version = "1.5.7";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "koesterlab";
    repo = "yte";
    tag = "v${version}";
    hash = "sha256-mcg002lMUjrU/AAhioSBiB+vBIU9fAUBIKLoLS/9OVI=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    dpath
    plac
    pyyaml
  ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "yte" ];

  pytestFlagsArray = [ "tests.py" ];

  preCheck = ''
    # The CLI test need yte on the PATH
    export PATH=$out/bin:$PATH
  '';

  meta = with lib; {
    description = "YAML template engine with Python expressions";
    homepage = "https://github.com/koesterlab/yte";
    changelog = "https://github.com/yte-template-engine/yte/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "yte";
  };
}
