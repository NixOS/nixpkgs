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
  versionCheckHook,
  bashInteractive,
  click,
  fish,
  zsh,
}:

buildPythonPackage (finalAttrs: {
  pname = "shtab";
  version = "1.14.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tqdm";
    repo = "shtab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yC3Vadfx/LxsG6bqNRrSDggqYjd/8BSYvhfVHbl/7Cs=";
  };

  nativeBuildInputs = [
    installShellFiles
    setuptools
    setuptools-scm
  ];

  nativeCheckInputs = [
    bashInteractive
    click
    fish
    pytestCheckHook
    pytest-cov-stub
    versionCheckHook
    zsh
  ];

  pythonImportsCheck = [ "shtab" ];

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd shtab \
        --bash <("$out/bin/shtab" --print-own-completion bash) \
        --fish <("$out/bin/shtab" --print-own-completion fish) \
        --zsh <("$out/bin/shtab" --print-own-completion zsh)
  '';

  meta = {
    description = "Automagic shell tab completion for Python CLI applications";
    mainProgram = "shtab";
    homepage = "https://tqdm.github.io/shtab/";
    changelog = "https://github.com/tqdm/shtab/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
