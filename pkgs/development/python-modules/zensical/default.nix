{
  lib,
  buildPythonPackage,
  fetchPypi,
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
  version = "0.0.72";
  pyproject = true;

  # We fetch from PyPi, because GitHub repo does not contain all sources.
  # The publish process also copies in assets from zensical/ui.
  # We could combine sources, but then nix-update won't work.
  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-KAH82Lrsbk0UraET4DpvtMbsLvolGNwK6U7lTtcclPE=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-jedNaGBR3sjVt5CrNlTgDax0KmFnqJEgkMsBiGWHhPc=";
  };

  nativeBuildInputs = with rustPlatform; [
    maturinBuildHook
    cargoSetupHook
  ];

  dependencies = [
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
    maintainers = with lib.maintainers; [ aljazerzen ];
    mainProgram = "zensical";
  };
})
