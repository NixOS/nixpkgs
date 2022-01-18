{ buildPythonPackage
, cloudpickle
, dm-haiku
, einops
, fetchFromGitHub
, flax
, hypothesis
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
  version = "0.6.7";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "cgarciae";
    repo = pname;
    rev = version;
    sha256 = "1hl3wj71c7cp7jzkhyjy7xgs2vc8c89icq0bgfr49y4pwv69n43m";
  };

  patches = [
    ./relax-deps.patch
  ];

  nativeBuildInputs = [
    poetry-core
  ];

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
