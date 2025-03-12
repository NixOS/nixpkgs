{
  lib,
  buildPythonPackage,
  pkgs,
  fetchFromGitHub,
  python3Packages,
  hatch,
  typeguard,
  docstring-parser,
  typing-extensions,
  rich,
  shtab,
  # Test dependencies
  pyyaml,
  pytest,
  pytest-cov,
  pytest-xdist,
  omegaconf,
  attrs,
  torch,
  pyright,
  ruff,
  mypy,
  numpy,
  flax,
  pydantic,
  coverage,
  eval-type-backport,
}:

buildPythonPackage rec {
  pname = "tyro";
  version = "0.9.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "brentyi";
    repo = "tyro";
    tag = "v${version}";
    sha256 = "sha256-dI6U9t4Y5TxhB710uuTmr9IgRLOEvZ9ZEWyHSWmrxag=";
  };

  build-system = [ hatch ];
  # nativeBuildInputs = [ setuptools-scm ];

  dependencies = [
    typeguard
    docstring-parser
    typing-extensions
    rich
    shtab
  ];

  nativeCheckInputs = [
    pytest
    pytest-cov
    pytest-xdist
    pyyaml
    omegaconf
    attrs
    torch
    pyright
    ruff
    mypy
    numpy
    flax
    pydantic
    coverage
    eval-type-backport
  ];

  checkPhase = ''
    pytest
  '';

  doCheck = true;

  pythonImportsCheck = [ "tyro" ];

  meta = with lib; {
    description = "CLI interfaces & config objects, from types";
    homepage = "https://github.com/brentyi/tyro";
    license = licenses.mit;
    maintainers = with maintainers; [ hoh ];
  };
}
