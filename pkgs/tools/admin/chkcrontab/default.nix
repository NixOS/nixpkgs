<<<<<<< HEAD
{ lib, python3, fetchPypi }:
=======
{ python3, lib }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

with python3.pkgs;

buildPythonApplication rec {
  pname = "chkcrontab";
  version = "1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0gmxavjkjkvjysgf9cf5fcpk589gb75n1mn20iki82wifi1pk1jn";
  };

  meta = with lib; {
    description = "A tool to detect crontab errors";
    license = licenses.asl20;
<<<<<<< HEAD
    maintainers = with maintainers; [ ];
=======
    maintainers = with maintainers; [ SuperSandro2000 ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    homepage = "https://github.com/lyda/chkcrontab";
  };
}
