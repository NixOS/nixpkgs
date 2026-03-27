{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  hatchling,

  # dependencies
  docstring-parser,
  rich,
  shtab,
  typeguard,
  typing-extensions,

  # tests
  attrs,
  flax,
  jax,
  ml-collections,
  msgspec,
  omegaconf,
  pydantic,
  pytestCheckHook,
  torch,
  universal-pathlib,
}:

buildPythonPackage (finalAttrs: {
  pname = "tyro";
  version = "1.0.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brentyi";
    repo = "tyro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k8f0eSeBBCROSsf7WooapDIFoy1G4Guxpbb7eNbj6ps=";
  };

  build-system = [ hatchling ];

  dependencies = [
    docstring-parser
    rich
    shtab
    typeguard
    typing-extensions
  ];

  nativeCheckInputs = [
    attrs
    flax
    jax
    ml-collections
    msgspec
    omegaconf
    pydantic
    pytestCheckHook
    torch
    universal-pathlib
  ];

  disabledTests = lib.optionals (pythonAtLeast "3.13") [
    # Bash path completion relies on the programmable-completion builtin `compgen`,
    # which is unavailable in the stdenv build shell.
    "test_bash_path_completion_marker"

    # In Nix builds, the long `python -m pytest` argv[0] path gets line-wrapped in
    # argparse error output, splitting `class-b` and `)` so this literal-match fails.
    "test_similar_arguments_subcommands_multiple_contains_match"

    # Same wrapped-output literal-match issue as above for the cascading-args variant.
    "test_similar_arguments_subcommands_multiple_contains_match_cascading"
  ];

  pythonImportsCheck = [ "tyro" ];

  meta = {
    description = "CLI interfaces & config objects, from types";
    homepage = "https://github.com/brentyi/tyro";
    changelog = "https://github.com/brentyi/tyro/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hoh ];
  };
})
