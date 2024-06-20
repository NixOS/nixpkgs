{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  rx,
  pytestCheckHook,
  responses,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "twitch-python";
  version = "0.0.20";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-bgnXIQuOCrtoknZ9ciB56zWxTCnncM2032TVaey6oXw=";
  };

  disabled = !isPy3k;

  postPatch = ''
    substituteInPlace setup.py --replace "'pipenv'," ""
  '';

  propagatedBuildInputs = [
    requests
    rx
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "twitch" ];

  meta = with lib; {
    description = "Twitch module for Python";
    homepage = "https://github.com/PetterKraabol/Twitch-Python";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
