<<<<<<< HEAD
{ lib, python3Packages, fetchPypi }:
=======
{ lib, python3Packages }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonPackage rec {
  pname = "doge";
  version = "3.5.0";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "0lwdl06lbpnaqqjk8ap9dsags3bzma30z17v0zc7spng1gz8m6xj";
  };

  meta = with lib; {
    homepage = "https://github.com/thiderman/doge";
    description = "wow very terminal doge";
    license = licenses.mit;
    maintainers = with maintainers; [ Gonzih ];
  };
}
