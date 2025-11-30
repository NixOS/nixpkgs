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
  version = "1.9.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "koesterlab";
    repo = "yte";
    tag = "v${version}";
    hash = "sha256-NaBzcy0HJ7IVR8Gto9NM0T+72qTl1ZS4i+2tq431O/M=";
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

  meta = with lib; {
    description = "YAML template engine with Python expressions";
    homepage = "https://github.com/koesterlab/yte";
    changelog = "https://github.com/yte-template-engine/yte/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "yte";
  };
}
