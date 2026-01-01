{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
<<<<<<< HEAD
=======
  isPy27,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pytestCheckHook,
  setuptools,
  numpy,
  pandas,
  xarray,
  traitlets,
}:

<<<<<<< HEAD
buildPythonPackage rec {
  pname = "traittypes";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jupyter-widgets";
    repo = "traittypes";
    tag = version;
    hash = "sha256-RwEZs4QFK+IrPFPBI7+jnQSFQryQFzEbrnOF8OyExuk=";
  };

=======
buildPythonPackage {
  pname = "traittypes";
  version = "0.2.1-unstable-2020-07-17";
  pyproject = true;

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jupyter-widgets";
    repo = "traittypes";
    rev = "af2ebeec9e58b73a12d4cf841bd506d6eadb8868";
    hash = "sha256-q7kt8b+yDHsWML/wCeND9PrZMVjemhzG7Ih1OtHbnTw=";
  };

  postPatch = ''
    substituteInPlace traittypes/tests/test_traittypes.py \
      --replace-fail "np.int" "int"
  '';

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  build-system = [ setuptools ];

  dependencies = [ traitlets ];

  nativeCheckInputs = [
    numpy
    pandas
    xarray
    pytestCheckHook
  ];

<<<<<<< HEAD
  disabledTests = [
    # AssertionError; see https://github.com/jupyter-widgets/traittypes/issues/55
    "test_initial_values"
  ];

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pythonImportsCheck = [ "traittypes" ];

  meta = {
    description = "Trait types for NumPy, SciPy, XArray, and Pandas";
    homepage = "https://github.com/jupyter-widgets/traittypes";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
