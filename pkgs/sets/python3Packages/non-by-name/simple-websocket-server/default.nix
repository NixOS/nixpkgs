{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage {
  pname = "simple-websocket-server";
  version = "20180414";
  format = "setuptools";
  src = fetchFromGitHub {
    owner = "dpallot";
    repo = "simple-websocket-server";
    rev = "34e6def93502943d426fb8bb01c6901341dd4fe6";
    hash = "sha256-xaIEKgE1jgeoxs6/s27+nrKSV6oJ+suCjun1TXq7LKc=";
  };

  doCheck = false; # no tests

  meta = {
    description = "Python based websocket server that is simple and easy to use";
    homepage = "https://github.com/dpallot/simple-websocket-server/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ rvolosatovs ];
    platforms = lib.platforms.all;
  };
}
