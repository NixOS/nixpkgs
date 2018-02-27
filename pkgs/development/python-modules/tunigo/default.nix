{ lib, buildPythonPackage, fetchFromGitHub, requests, mock, nose }:

buildPythonPackage rec {
  pname = "tunigo";
  version = "1.0.0";

  propagatedBuildInputs = [ requests ];

  src = fetchFromGitHub {
    owner = "trygveaa";
    repo = "python-tunigo";
    rev = "v${version}";
    sha256 = "07q9girrjjffzkn8xj4l3ynf9m4psi809zf6f81f54jdb330p2fs";
  };

  checkInputs = [ mock nose ];

  meta = with lib; {
    description = "Python API for the browse feature of Spotify";
    homepage = https://github.com/trygveaa/python-tunigo;
    license = licenses.asl20;
  };
}
