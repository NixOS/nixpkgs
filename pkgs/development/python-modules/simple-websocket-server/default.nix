{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage {
  pname = "simple-websocket-server";
  version = "20180414";
  format = "setuptools";
  src = fetchFromGitHub {
    owner = "dpallot";
    repo = "simple-websocket-server";
    rev = "34e6def93502943d426fb8bb01c6901341dd4fe6";
    sha256 = "19rcpdx4vxg9is1cpyh9m9br5clyzrpb7gyfqsl0g3im04m098n5";
  };

  doCheck = false; # no tests

  meta = with lib; {
    description = "A python based websocket server that is simple and easy to use";
    homepage = "https://github.com/dpallot/simple-websocket-server/";
    license = licenses.mit;
    maintainers = with maintainers; [ rvolosatovs ];
    platforms = platforms.all;
  };
}
