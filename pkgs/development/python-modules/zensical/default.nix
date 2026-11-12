{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  rustPlatform,
  versionCheckHook,

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
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zensical";
    repo = "zensical";
    rev = "v${finalAttrs.version}";
    hash = "sha256-dhNQe6fnKeEN/8LmMWWAP6dyFsB5iUKLdsYKQiyP5Go=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-sVAWbIii0f+murNRcEy7w/+BR7/mrjqBhMop7DYdmmM=";
  };

  nativeBuildInputs = with rustPlatform; [
    maturinBuildHook
    cargoSetupHook
  ];

  ui = buildPythonPackage (finalAttrs: {
    pname = "zensical-ui";
    version = "0.0.41";
    pyproject = true;
    src = fetchFromGitHub {
      owner = "zensical";
      repo = "ui";
      rev = "v${finalAttrs.version}";
      hash = "sha256-pgygAqMMRQckjFmfEhG3p6YHcQUGs1M7drEMvSEbt24=";
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
