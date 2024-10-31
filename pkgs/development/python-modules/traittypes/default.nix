{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  isPy27,
  pytestCheckHook,
  setuptools,
  numpy,
  pandas,
  xarray,
  traitlets,
}:

buildPythonPackage rec {
  pname = "traittypes";
  version = "0.2.1-unstable-2020-07-17";
  pyproject = true;

  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jupyter-widgets";
    repo = pname;
    rev = "af2ebeec9e58b73a12d4cf841bd506d6eadb8868";
    hash = "sha256-q7kt8b+yDHsWML/wCeND9PrZMVjemhzG7Ih1OtHbnTw=";
  };

  postPatch = ''
    substituteInPlace traittypes/tests/test_traittypes.py \
      --replace-fail "np.int" "int"
  '';

  build-system = [ setuptools ];

  dependencies = [ traitlets ];

  nativeCheckInputs = [
    numpy
    pandas
    xarray
    pytestCheckHook
  ];

  pythonImportsCheck = [ "traittypes" ];

  meta = {
    description = "Trait types for NumPy, SciPy, XArray, and Pandas";
    homepage = "https://github.com/jupyter-widgets/traittypes";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
