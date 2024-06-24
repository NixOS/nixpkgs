{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "tell-me-your-secrets";
  version = "2.4.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "valayDave";
    repo = "tell-me-your-secrets";
    rev = "refs/tags/v${version}";
    hash = "sha256-3ZJyL/V1dsW6F+PiEhnWpv/Pz2H9/UKSJWDgw68M/Z8=";
  };

  pythonRelaxDeps = [
    "gitignore-parser"
    "pandas"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    gitignore-parser
    pandas
    pyyaml
    single-source
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "tell_me_your_secrets"
  ];

  meta = with lib; {
    description = "Tools to find secrets from various signatures";
    mainProgram = "tell-me-your-secrets";
    homepage = "https://github.com/valayDave/tell-me-your-secrets";
    changelog = "https://github.com/valayDave/tell-me-your-secrets/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
