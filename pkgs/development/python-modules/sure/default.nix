{ lib
, buildPythonPackage
, fetchPypi
, rednose
, six
, mock
, isPyPy
}:

buildPythonPackage rec {
  pname = "sure";
  version = "2.0.1";
  format = "setuptools";

  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-yPxvq8Dn9phO6ruUJUDkVkblvvC7mf5Z4C2mNOTUuco=";
  };

  propagatedBuildInputs = [
    six
    mock
  ];

  nativeCheckInputs = [
    rednose
  ];

  pythonImportsCheck = [
    "sure"
  ];

  meta = with lib; {
    description = "Utility belt for automated testing";
    homepage = "https://sure.readthedocs.io/";
    changelog = "https://github.com/gabrielfalcao/sure/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
