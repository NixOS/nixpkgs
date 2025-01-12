{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  docstring-parser,
  typing-extensions,
  colorama,
  rich,
  shtab,
  pytestCheckHook,
  pyyaml,
  frozendict,
  omegaconf,
  attrs,
  torch,
  numpy,
  pydantic,
  jax,
  flax,
}:

buildPythonPackage rec {
  pname = "tyro";
  version = "0.8.14";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brentyi";
    repo = "tyro";
    rev = "refs/tags/v${version}";
    hash = "sha256-ipkAgeHvKDbprRPNIC8XQtEi7TNo0rXgjs9TyM7mjPg=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [ "docstring-parser" ];

  dependencies = [
    docstring-parser
    typing-extensions
    colorama
    rich
    shtab
  ];

  # torch and such are currently only supported on 3.11 and below.
  doCheck = pythonOlder "3.12";

  nativeCheckInputs = [
    pytestCheckHook
    pyyaml
    frozendict
    omegaconf
    attrs
    torch
    numpy
    pydantic
    jax
    flax
  ];

  pythonImportsCheck = [ "tyro" ];

  meta = {
    changelog = "https://github.com/brentyi/tyro/releases/tag/v${version}";
    description = "CLI interfaces & config objects, from types";
    homepage = "https://brentyi.github.io/tyro/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
