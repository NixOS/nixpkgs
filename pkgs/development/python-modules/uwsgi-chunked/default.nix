{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
}:

buildPythonPackage rec {
  pname = "uwsgi-chunked";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "btimby";
    repo = "uwsgi-chunked";
    rev = version;
    hash = "sha256-5TNCnQhnT1gAblgs+AAW62HoNDPM54hpxgCnYl07j3I=";
  };

  build-system = [
    setuptools
    wheel
  ];

  pythonImportsCheck = [ "uwsgi_chunked" ];

  meta = with lib; {
    description = "WSGI application wrapper that handles Transfer-Encoding: chunked";
    homepage = "https://github.com/btimby/uwsgi-chunked/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
