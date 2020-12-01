{ lib
, buildPythonPackage
, fetchPypi
, isPy27
, six
, decorator
, pytestCheckHook
, isort
, flake8
}:

buildPythonPackage rec {
  pname = "validators";
  version = "0.18.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1a653b33c0ab091790f65f42b61aa191e354ed5fdedfeb17d24a86d0789966d7";
  };

  propagatedBuildInputs = [
    six
    decorator
  ];

  checkInputs = [
    pytestCheckHook
    flake8
    isort
  ];

  disabledTests = lib.optionals isPy27 [ "url" ];

  meta = with lib; {
    description = "Python Data Validation for Humans™";
    homepage = "https://github.com/kvesteri/validators";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
