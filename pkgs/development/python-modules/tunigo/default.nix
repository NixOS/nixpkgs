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
    sha256 = "07q9girrjjffzkn8xj4l3ynf9m4psi809zf6f81f54jdb330p2fs";
  };

  nativeCheckInputs = [
    mock
    responses
    pytest
  ];

  checkPhase = ''
    py.test
  '';

  meta = with lib; {
    description = "Python API for the browse feature of Spotify";
    homepage = "https://github.com/trygveaa/python-tunigo";
    license = licenses.asl20;
  };
}
