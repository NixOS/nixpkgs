{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  hatch,
  typeguard,
  docstring-parser,
  typing-extensions,
  rich,
  shtab,
  # Test dependencies
  omegaconf,
  attrs,
  torch,
  flax,
  pydantic,
  jax,
}:

buildPythonPackage rec {
  pname = "tyro";
  version = "0.9.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brentyi";
    repo = "tyro";
    tag = "v${version}";
    hash = "sha256-dI6U9t4Y5TxhB710uuTmr9IgRLOEvZ9ZEWyHSWmrxag=";
  };

  build-system = [ hatch ];

  dependencies = [
    typeguard
    docstring-parser
    typing-extensions
    rich
    shtab
  ];

  nativeCheckInputs = [
    omegaconf
    torch
    pydantic
    jax
    flax
    attrs
    pytestCheckHook
  ];

  pythonImportsCheck = [ "tyro" ];

  meta = {
    description = "CLI interfaces & config objects, from types";
    homepage = "https://github.com/brentyi/tyro";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hoh ];
  };
}
