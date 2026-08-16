{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  matplotlib,
  pytestCheckHook,
  setuptools,
  scipy,
  scikit-learn,
}:

buildPythonPackage (finalAttrs: {
  pname = "tadasets";
  version = "0.2.2";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-C+l19J0PHjZTlzAhXbojicaOyr/gjN8fuH7cLyb449w=";
  };

  build-system = [ setuptools ];

  dependencies = [
    numpy
    matplotlib
  ];

  nativeCheckInputs = [
    pytestCheckHook
    scipy
    scikit-learn
  ];

  meta = {
    description = "Great data sets for Topological Data Analysis";
    homepage = "https://tadasets.scikit-tda.org";
    changelog = "https://github.com/scikit-tda/tadasets/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
})
