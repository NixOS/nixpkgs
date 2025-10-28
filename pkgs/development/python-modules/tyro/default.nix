{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

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
}:

buildPythonPackage rec {
  pname = "tyro";
  version = "0.9.35";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brentyi";
    repo = "tyro";
    tag = "v${version}";
    hash = "sha256-W1AtdZslaQ+lBR8vTmiq+MprDjqXc8fSWZ/63mS2obY=";
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
  ];

  pythonImportsCheck = [ "tyro" ];

  meta = {
    description = "CLI interfaces & config objects, from types";
    homepage = "https://github.com/brentyi/tyro";
    changelog = "https://github.com/brentyi/tyro/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hoh ];
  };
}
