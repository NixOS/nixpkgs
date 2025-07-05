{
  buildPythonPackage,
  cloudpickle,
  dm-haiku,
  einops,
  fetchFromGitHub,
  flax,
  hypothesis,
  jaxlib,
  keras,
  lib,
  poetry-core,
  pytestCheckHook,
  pyyaml,
  rich,
  tensorflow,
  treeo,
  torchmetrics,
  torch,
}:

buildPythonPackage rec {
  pname = "treex";
  version = "0.6.11";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "cgarciae";
    repo = "treex";
    tag = version;
    hash = "sha256-ObOnbtAT4SlrwOms1jtn7/XKZorGISGY6VuhQlC3DaQ=";
  };

  # At the time of writing (2022-03-29), rich is currently at version 11.0.0.
  # The treeo dependency is compatible with a patch, but not marked as such in
  # treex. See https://github.com/cgarciae/treex/issues/68.
  pythonRelaxDeps = [
    "certifi"
    "flax"
    "rich"
    "treeo"
  ];

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [ jaxlib ];

  propagatedBuildInputs = [
    einops
    flax
    pyyaml
    rich
    treeo
    torch
  ];

  nativeCheckInputs = [
    cloudpickle
    dm-haiku
    hypothesis
    keras
    pytestCheckHook
    tensorflow
    torchmetrics
  ];

  pythonImportsCheck = [ "treex" ];

  meta = with lib; {
    description = "Pytree Module system for Deep Learning in JAX";
    homepage = "https://github.com/cgarciae/treex";
    license = licenses.mit;
    maintainers = with maintainers; [ ndl ];
  };
}
