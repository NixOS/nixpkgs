{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  hatchling,

  # dependencies
  docstring-parser,
  typeguard,
  typing-extensions,

  # tests
  attrs,
  ml-collections,
  msgspec,
  omegaconf,
  pydantic,
  pytestCheckHook,
  shtab,
  universal-pathlib,
}:

buildPythonPackage (finalAttrs: {
  pname = "tyro";
  version = "1.0.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brentyi";
    repo = "tyro";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e4LIJzZ7lIkvhqbOz/EGHgPo9ri1HNiMp0j+I1S0/J4=";
  };

  build-system = [ hatchling ];

  dependencies = [
    docstring-parser
    typeguard
    typing-extensions
  ];

  # Upstream's neural-network integration tests are optional and skipped when
  # flax/torch are unavailable, so keep the lightweight dev extras only.
  nativeCheckInputs = [
    attrs
    ml-collections
    msgspec
    omegaconf
    pydantic
    pytestCheckHook
    shtab
    universal-pathlib
  ];

  disabledTests =
    lib.optionals (pythonAtLeast "3.13") [
      # The bash path-completion functional test still returns no file
      # completions in the Nix build environment.
      "test_bash_path_completion_marker"
    ]
    ++ lib.optionals (pythonAtLeast "3.14") [
      # Upstream checks that the literal substring `bc` never appears in the
      # help text, but under Nix the `python -m pytest` runner path can include
      # that substring in the store hash used for `sys.argv[0]`.
      "test_suppress_subcommand"
    ];

  # Keep argparse help output on a single line where possible so the
  # literal-output tests do not fail due to terminal line wrapping.
  preCheck = ''
    export COLUMNS=200
    export LINES=200
  '';

  pythonImportsCheck = [ "tyro" ];

  meta = {
    description = "CLI interfaces & config objects, from types";
    homepage = "https://github.com/brentyi/tyro";
    changelog = "https://github.com/brentyi/tyro/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hoh ];
  };
})
