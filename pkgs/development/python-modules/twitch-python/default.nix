{ buildPythonPackage
, fetchPypi
, lib
, pythonOlder
, requests
, responses
, rx
}:

buildPythonPackage rec {
  pname = "twitch-python";
  version = "0.0.17";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11cfvj2smq6nqyngdlwkdzq6ikcb2wadzavigbd83fma9v714x0k";
  };

  patches = [ ./setup-no-pipenv.patch ];

  propagatedBuildInputs =  [ requests rx ];
  checkInputs = [ responses ];

  meta = with lib; {
    description = "Object-oriented Twitch API for Python developers";
    homepage = "https://github.com/PetterKraabol/Twitch-Python";
    license = licenses.mit;
    maintainers = with maintainers; [ strager ];
  };
}
