{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  numpy,
  sphinx,
  six,
}:

buildPythonPackage {
  pname = "sphinx-fortran";
  version = "unstable-2025-10-03";
  format = "setuptools";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "VACUMM";
    repo = "sphinx-fortran";
    rev = "b14f438c1cc74d1dbcd5acd9a330c3b509caab56";
    hash = "sha256-baWzxtu285z9BIH5HzMTASo2nZpOk3Q0rKcdkoul588=";
  };

  propagatedBuildInputs = [
    numpy
    sphinx
    six
  ];

  pythonImportsCheck = [ "sphinxfortran" ];

  nativeCheckInputs = [ pytestCheckHook ];

  meta = with lib; {
    description = "Fortran domain and autodoc extensions to Sphinx";
    homepage = "http://sphinx-fortran.readthedocs.org/";
    license = licenses.cecill21;
    maintainers = with maintainers; [ loicreynier ];
  };
}
