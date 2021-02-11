{ lib, buildPythonPackage, fetchPypi, requests, rx, pytestCheckHook, responses, isPy3k }:

buildPythonPackage rec {
  pname = "twitch-python";
  version = "0.0.19";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b0b02abdd33458e4ffabc632aa6a6779f3599e188819632551353b6c5553f5c5";
  };

  disabled = !isPy3k;

  postPatch = ''
    substituteInPlace setup.py --replace "'pipenv'," ""
  '';

  propagatedBuildInputs = [ requests rx ];

  checkInputs = [ pytestCheckHook responses ];

  pythonImportsCheck = [ "twitch" ];

  meta = with lib; {
    description = "Twitch module for Python";
    homepage = "https://github.com/PetterKraabol/Twitch-Python";
    license = licenses.mit;
    maintainers = with maintainers; [ marsam ];
  };
}
