<<<<<<< HEAD
{ lib, python3Packages, fetchPypi }:
=======
{ lib, fetchurl, python3Packages }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonPackage rec {
  pname = "hyp-server";
  version = "1.2.0";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "1lafjdcn9nnq6xc3hhyizfwh6l69lc7rixn6dx65aq71c913jc15";
  };

  meta = with lib; {
    description = "Hyperminimal https server";
    homepage    = "https://github.com/rnhmjoj/hyp";
    license     = with licenses; [gpl3Plus mit];
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.unix;
  };
}
