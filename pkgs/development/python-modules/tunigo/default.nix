{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  mock,
  responses,
  pytest,
}:

buildPythonPackage rec {
  pname = "tunigo";
  version = "1.0.0";
  format = "setuptools";

  propagatedBuildInputs = [ requests ];

  src = fetchFromGitHub {
    owner = "trygveaa";
    repo = "python-tunigo";
    rev = "v${version}";
    hash = "sha256-2okLxlhNkuICcsb9BFDUl9TkrB+UyI7s/M5JmXN8CR8=";
  };

  nativeCheckInputs = [
    mock
    responses
    pytest
  ];

  checkPhase = ''
    py.test
  '';

  meta = {
    description = "Python API for the browse feature of Spotify";
    homepage = "https://github.com/trygveaa/python-tunigo";
    license = lib.licenses.asl20;
  };
}
