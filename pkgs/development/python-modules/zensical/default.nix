{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  nix-update,
  nix,
  rustPlatform,
  versionCheckHook,
  writeShellApplication,
  yq-go,

  # dependencies
  click,
  deepmerge,
  jinja2,
  markdown,
  pathspec,
  pygments,
  pymdown-extensions,
  pyyaml,
  tomli,
}:

buildPythonPackage (finalAttrs: {
  pname = "zensical";
  version = "0.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zensical";
    repo = "zensical";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ssdnmg1bvRxcNfjKCleKDA4XOuOru1nLuVVX+B5qMls=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-bse528U80zjZSXcGNpzJtJGlujCFhpPiBTcJ/vzoneg=";
  };

  nativeBuildInputs = with rustPlatform; [
    maturinBuildHook
    cargoSetupHook
  ];

  ui = buildPythonPackage (finalAttrs: {
    pname = "zensical-ui";
    version = "0.0.42";
    pyproject = true;
    src = fetchFromGitHub {
      owner = "zensical";
      repo = "ui";
      rev = "v${finalAttrs.version}";
      hash = "sha256-FAdE3QH1WXAIQpt/yQ+d4lxxpNJdqemDqBcOcv5y3JA=";
    };
    build-system = [ hatchling ];
  });

  dependencies = [
    finalAttrs.ui
    click
    deepmerge
    jinja2
    markdown
    pathspec
    pygments
    pymdown-extensions
    pyyaml
    tomli
  ];

  pythonImportsCheck = [ "zensical" ];

  nativeCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  passthru.updateScript = lib.getExe (writeShellApplication {
    name = "zensical-update";
    runtimeInputs = [
      nix
      nix-update
      yq-go
    ];
    text = ''
      nix-update zensical
      toml=$(nix-instantiate --eval -A zensical.src.outPath --json | yq -r)/pyproject.toml
      version=$(yq -r '.project.dependencies[] | select(test("^zensical-ui==")) | sub("^zensical-ui=="; "")' "$toml")
      nix-update zensical.ui --version "$version"
    '';
  });

  meta = {
    description = "Static site generator for documentation";
    longDescription = ''
      Zensical is a modern static site generator designed to simplify
      building and maintaining project documentation.  It's built by
      the creators of Material for MkDocs and shares the same core
      design principles and philosophy – batteries included, easy to
      use, with powerful customization options.
    '';
    homepage = "https://zensical.org";
    changelog = "https://github.com/zensical/zensical/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      aljazerzen
      zowoq
    ];
    mainProgram = "zensical";
  };
})
