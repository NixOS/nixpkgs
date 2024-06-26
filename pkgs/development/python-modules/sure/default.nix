{
  lib,
  buildPythonPackage,
  fetchPypi,
  nose,
  mock,
  six,
  isPyPy,
  pythonOlder,
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

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "rednose = 1" ""
  '';

  propagatedBuildInputs = [
    mock
    six
  ];

  doCheck = pythonOlder "3.12"; # nose requires imp module

  nativeCheckInputs = [ nose ];

  pythonImportsCheck = [ "sure" ];

  meta = with lib; {
    description = "Utility belt for automated testing";
    mainProgram = "sure";
    homepage = "https://sure.readthedocs.io/";
    changelog = "https://github.com/gabrielfalcao/sure/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
