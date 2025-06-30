{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  scikit-learn,
  pandas,
  pytestCheckHook,
  pytest-cov-stub,
  pytest-xdist,
  pytz,
}:

buildPythonPackage rec {
  pname = "sklearn-compat";
  version = "0.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sklearn-compat";
    repo = "sklearn-compat";
    tag = version;
    hash = "sha256-9Py5VKDej7xDMdWVujkS/ooxOkEcjPJNlBHkbe/rycE=";
  };

  build-system = [
    hatchling
  ];

  dependencies = [
    scikit-learn
  ];

  nativeCheckInputs = [
    pandas
    pytestCheckHook
    pytest-cov-stub
    pytest-xdist
    pytz
  ];

  pythonImportsCheck = [
    "sklearn_compat"
  ];

  meta = {
    description = "Ease multi-version support for scikit-learn compatible library";
    homepage = "https://github.com/sklearn-compat/sklearn-compat";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ philipwilk ];
  };
}
