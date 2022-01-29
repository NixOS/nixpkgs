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
  version = "0.6.8";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "cgarciae";
    repo = pname;
    rev = version;
    sha256 = "0pi4c78vqhy7mh9ranssdxdjbqnvyagsfkx95k93bnvzgmnr2kxb";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'rich = "^10.7.0"' 'rich = ">=10.7.0"' \
      --replace 'PyYAML = "^5.4.1"' 'PyYAML = ">=5.4.1"' \
      --replace 'optax = "^0.0.9"' 'optax = ">=0.0.9"'
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
