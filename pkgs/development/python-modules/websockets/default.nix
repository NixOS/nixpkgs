{ lib
, fetchFromGitHub
, buildPythonPackage
, pythonOlder
, pytest
, stdenv
}:

buildPythonPackage rec {
  pname = "websockets";
  version = "8.0.2";

  src = fetchFromGitHub {
    owner = "aaugustin";
    repo = pname;
    rev = version;
    sha256 = "02fgb8gib4z5fqv30brz3mhxmblw9bw0978fhpjdrkj7wvqrz5h8";
  };

  disabled = pythonOlder "3.3";

  # Tests fail on Darwin with `OSError: AF_UNIX path too long`
  doCheck = !stdenv.isDarwin;

  meta = with lib; {
    description = "WebSocket implementation in Python 3";
    homepage = "https://github.com/aaugustin/websockets";
    license = licenses.bsd3;
  };
}
