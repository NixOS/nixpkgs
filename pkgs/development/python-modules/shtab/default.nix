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
  version = "1.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tqdm";
    repo = "shtab";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mbki7g0BuMfrSa107nXuvySbxp1AVhGfWFJSVQe6sYE=";
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
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
