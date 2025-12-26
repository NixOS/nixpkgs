{
  lib,
  argparse-dataclass,
  buildPythonPackage,
  dpath,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  pyyaml,
  uv-build,
}:

buildPythonPackage rec {
  pname = "yte";
  version = "1.9.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "koesterlab";
    repo = "yte";
    tag = "v${version}";
    hash = "sha256-TpY13HYBZ4qL2W6sPdoM+bpHcEOi0rwubCbFa4zm2I0=";
  };

  build-system = [ uv-build ];

  dependencies = [
    dpath
    argparse-dataclass
    pyyaml
  ];

  nativeCheckInputs = [
    numpy
    pytestCheckHook
  ];

  pythonImportsCheck = [ "yte" ];

  preCheck = ''
    # The CLI test need yte on the PATH
    export PATH=$out/bin:$PATH
  '';

  meta = {
    description = "YAML template engine with Python expressions";
    homepage = "https://github.com/koesterlab/yte";
    changelog = "https://github.com/yte-template-engine/yte/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "yte";
  };
}
