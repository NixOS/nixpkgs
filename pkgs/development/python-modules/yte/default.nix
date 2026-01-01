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
<<<<<<< HEAD
  version = "1.9.4";
=======
  version = "1.9.3";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "koesterlab";
    repo = "yte";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-TpY13HYBZ4qL2W6sPdoM+bpHcEOi0rwubCbFa4zm2I0=";
=======
    hash = "sha256-NaBzcy0HJ7IVR8Gto9NM0T+72qTl1ZS4i+2tq431O/M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    description = "YAML template engine with Python expressions";
    homepage = "https://github.com/koesterlab/yte";
    changelog = "https://github.com/yte-template-engine/yte/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "YAML template engine with Python expressions";
    homepage = "https://github.com/koesterlab/yte";
    changelog = "https://github.com/yte-template-engine/yte/blob/${src.tag}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "yte";
  };
}
