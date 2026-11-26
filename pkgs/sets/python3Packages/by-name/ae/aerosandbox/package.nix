{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  numpy,
  scipy,
  pandas,
  matplotlib,
  seaborn,
  tqdm,
  sortedcontainers,
  dill,
  casadi,
  neuralfoil,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aerosandbox";
  version = "4.2.10";
  format = "wheel";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    format = "wheel";

    python = "py3";
    dist = "py3";
    hash = "sha256-QvS1tKZ/go+LiTAzuqkJOEw9e8O+cA1bPFWrahjB810=";
  };

  build-system = [ setuptools ];
  dependencies = [
    numpy
    scipy
    pandas
    matplotlib
    seaborn
    tqdm
    sortedcontainers
    dill
    casadi
  ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  pythonImportsCheck = [ "aerosandbox" ];

  optional-dependencies.neuralfoil = [ neuralfoil ];

  pythonRemoveDeps = [
    # NeuralFoil depends on AeroSandbox; select both in the Python environment.
    "neuralfoil"
    # not pypa-installed, so no metadata
    # good candidate for https://github.com/NixOS/nixpkgs/pull/518530
    "casadi"
  ];

  meta = {
    description = "Aircraft design optimization made fast through modern automatic differentiation";
    homepage = "https://peterdsharpe.github.io/AeroSandbox";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
