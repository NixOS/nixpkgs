{ lib
, buildPythonPackage
, requests
, six
, websocket-client
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "socketio-client";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "invisibleroads";
    repo = "socketio-client";
    rev = version;
    sha256 = "sha256-71sjiGJDDYElPGUNCH1HaVdvgMt8KeD/kXVDpF615ho=";
  };

  propagatedBuildInputs = [
    six
    websocket-client
    requests
  ];

  # Perform networking tests.
  doCheck = false;

  pythonImportsCheck = [
    "socketIO_client"
  ];

  meta = with lib; {
    description = "A socket.io client library for protocol 1.x";
    homepage = "https://github.com/invisibleroads/socketIO-client";
    license = licenses.mit;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
