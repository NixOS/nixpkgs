{
  lib,
  stdenvNoCC,
  buildPythonPackage,
  fetchFromGitHub,
  installShellFiles,
  pytestCheckHook,
  pytest-cov-stub,
  setuptools,
  setuptools-scm,
  bashInteractive,
  fish,
  zsh,
}:

buildPythonPackage (finalAttrs: {
  pname = "shtab";
  version = "1.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tqdm";
    repo = "shtab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O4F7fW+anH/DVqLFpOlPlHX9dAv4S3sG6SAYZkyOdUw=";
  };

  nativeBuildInputs = [
    installShellFiles
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    bashInteractive
    fish
    pytestCheckHook
    pytest-cov-stub
    zsh
  ];

  pythonImportsCheck = [ "shtab" ];

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    for SUPPORTED_SHELL in "bash" "fish" "zsh"; do
      installShellCompletion \
        --cmd shtab \
        "--$SUPPORTED_SHELL" <("$out/bin/shtab" --print-own-completion "$SUPPORTED_SHELL")
    done
  '';

  meta = {
    description = "Automagic shell tab completion for Python CLI applications";
    mainProgram = "shtab";
    homepage = "https://tqdm.github.io/shtab/";
    changelog = "https://github.com/tqdm/shtab/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
