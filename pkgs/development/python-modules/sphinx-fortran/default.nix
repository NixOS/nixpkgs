{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, future
, numpy
, sphinx
, six
}:

buildPythonPackage rec {
  pname = "sphinx-fortran";
  version = "unstable-2022-03-02";

  src = fetchFromGitHub {
    owner = "VACUMM";
    repo = pname;
    rev = "394ae990b43ed43fcff8beb048632f5e99794264";
    sha256 = "sha256-IVKu5u9gqs7/9EZrf4ZYd12K6J31u+/B8kk4+8yfohM=";
  };

  propagatedBuildInputs = [
    future
    numpy
    sphinx
    six
  ];

  pythonImportsCheck = [ "sphinxfortran" ];

  # Tests are failing because reference files are not updated
  doCheck = false;

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Fortran domain and autodoc extensions to Sphinx";
    homepage = "http://sphinx-fortran.readthedocs.org/";
    license = licenses.cecill21;
    maintainers = with maintainers; [ loicreynier ];
  };
}
