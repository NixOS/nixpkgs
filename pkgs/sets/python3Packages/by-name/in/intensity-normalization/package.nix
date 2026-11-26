{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  nibabel,
  numpy,
  scikit-fuzzy,
  scipy,
  typer,
  # nativeCheckInputs
  pytestCheckHook,
  pytest-cov-stub,
  hypothesis,
}:

buildPythonPackage (finalAttrs: {
  pname = "intensity-normalization";
  version = "4.0.0";
  pyproject = true;

  src = fetchPypi {
    pname = "intensity_normalization";
    inherit (finalAttrs) version;
    hash = "sha256-aKOyW5fxNksHTQurrClJGowuq4coDTID2m9KAQI7ZIQ=";
  };

  build-system = [ hatchling ];

  dependencies = [
    nibabel
    numpy
    scikit-fuzzy
    scipy
    typer
  ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    pytest-cov-stub
  ];
  enabledTestPaths = [ "tests" ];

  pythonImportsCheck = [
    "intensity_normalization"
  ];

  meta = {
    homepage = "https://github.com/jcreinhold/intensity-normalization";
    description = "MRI intensity normalization tools";
    changelog = "https://github.com/jcreinhold/intensity-normalization/releases/tag/${finalAttrs.version}";
    maintainers = with lib.maintainers; [ bcdarwin ];
    license = lib.licenses.asl20;
    mainProgram = "intensity-normalize";
  };
})
