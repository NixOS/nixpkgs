{ lib
, buildPythonPackage
, fetchFromGitHub
, six
, pycryptodomex
, requests
, urllib3
, vdf
, gevent
, gevent-eventemitter
, protobuf
, cachetools
, types-enum34
, cryptography
, mock
, pytest-vcr
}:

buildPythonPackage rec {
  pname = "steam";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "ValvePython";
    repo = "steam";
    rev = "v${version}";
    hash = "sha256-yXujem6lpkyOAeuTGgRcRN0G8rADp+xjvP+B9dZT0bg=";
  };

  propagatedBuildInputs = [
    six
    pycryptodomex
    requests
    urllib3
    vdf
    gevent
    gevent-eventemitter
    protobuf
    cachetools
    types-enum34
    cryptography
  ];

  nativeCheckInputs = [
    pytest-vcr
    mock
  ];

  pythonImportsCheck = [ "steam" ];
  # doCheck = false;

  meta = with lib; {
    description = "Python package for interacting with Steam";
    homepage = "https://github.com/ValvePython/steam";
    license = licenses.mit;
    # maintainers = with maintainers; [ ];
  };
}
