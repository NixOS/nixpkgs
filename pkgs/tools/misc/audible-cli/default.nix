{ lib, python3Packages, fetchFromGitHub, installShellFiles }:

python3Packages.buildPythonApplication rec {
  pname = "audible-cli";
  version = "0.2.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mkb79";
    repo = "audible-cli";
    rev = "refs/tags/v${version}";
    hash = "sha256-J81RcehFokOpsQBJLvmeihSrlMyX0geHPl3PPxvGjmY=";
  };

  nativeBuildInputs = with python3Packages; [
    pythonRelaxDepsHook
    setuptools
  ] ++ [
    installShellFiles
  ];

  propagatedBuildInputs = with python3Packages; [
    aiofiles
    audible
    click
    httpx
    packaging
    pillow
    questionary
    tabulate
    toml
    tqdm
  ];

  pythonRelaxDeps = [
    "httpx"
    "audible"
  ];

  postInstall = ''
    export PATH=$out/bin:$PATH
    installShellCompletion --cmd audible \
      --bash <(source utils/code_completion/audible-complete-bash.sh) \
      --fish <(source utils/code_completion/audible-complete-zsh-fish.sh) \
      --zsh <(source utils/code_completion/audible-complete-zsh-fish.sh)
  '';

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "audible_cli"
  ];

  meta = with lib; {
    description = "A command line interface for audible package. With the cli you can download your Audible books, cover, chapter files";
    license = licenses.agpl3Only;
    homepage = "https://github.com/mkb79/audible-cli";
    changelog = "https://github.com/mkb79/audible-cli/blob/${src.rev}/CHANGELOG.md";
    maintainers = with maintainers; [ jvanbruegge ];
    mainProgram = "audible";
  };
}
