{
  lib,
  stdenv,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "deepsecrets";
  version = "1.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "avito-tech";
    repo = "deepsecrets";
    tag = "v${version}";
    hash = "sha256-VfIsPgStHcIYGbfrOs1mvgoq0ZoVSZwILFVBeMt/5Jc=";
  };

  pythonRelaxDeps = [
    "pyyaml"
    "regex"
    "mmh3"
  ];

  build-system = with python3.pkgs; [ poetry-core ];

  dependencies = with python3.pkgs; [
    dotwiz
    mmh3
    ordered-set
    pydantic_1
    pygments
    pyyaml
    regex
  ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  disabledTests = [
    # assumes package is built in /app (docker?), and not /build/${src.name} (nix sandbox)
    "test_1_cli"
    "test_config"
    "test_basic_info"
  ];

  pythonImportsCheck = [ "deepsecrets" ];

  meta = {
    description = "Secrets scanner that understands code";
    homepage = "https://github.com/avito-tech/deepsecrets";
    changelog = "https://github.com/avito-tech/deepsecrets/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "deepsecrets";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
