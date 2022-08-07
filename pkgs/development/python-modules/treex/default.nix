{ buildPythonPackage
, cloudpickle
, dm-haiku
, einops
, fetchFromGitHub
, flax
, hypothesis
, jaxlib
, keras
, lib
, poetry-core
, pytestCheckHook
, pyyaml
, rich
, tensorflow
, treeo
}:

buildPythonPackage rec {
  pname = "treex";
  version = "0.6.10";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "cgarciae";
    repo = pname;
    rev = version;
    hash = "sha256-ZHfgmRNbFh8DFZkmilY0pmRNQhJFqT689I7Lu8FuFm4=";
  };

  # At the time of writing (2022-03-29), rich is currently at version 11.0.0.
  # The treeo dependency is compatible with a patch, but not marked as such in
  # treex. See https://github.com/cgarciae/treex/issues/68.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'rich = "^11.2.0"' 'rich = "*"' \
      --replace 'treeo = "^0.0.10"' 'treeo = "*"' \
      --replace 'certifi = "^2021.10.8"' 'certifi = "*"'
  '';

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
  ];

  checkInputs = [
    cloudpickle
    dm-haiku
    hypothesis
    keras
    pytestCheckHook
    tensorflow
  ];

  pythonImportsCheck = [
    "treex"
  ];

  disabledTestPaths = [
    # Require `torchmetrics` which is not packaged in `nixpkgs`.
    "tests/metrics/test_mean_absolute_error.py"
    "tests/metrics/test_mean_square_error.py"
  ];

  meta = with lib; {
    description = "Pytree Module system for Deep Learning in JAX";
    homepage = "https://github.com/cgarciae/treex";
    license = licenses.mit;
    maintainers = with maintainers; [ ndl ];
  };
}
