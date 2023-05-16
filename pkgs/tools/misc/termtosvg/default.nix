<<<<<<< HEAD
{ lib, python3Packages, fetchPypi }:
=======
{ lib, python3Packages }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonApplication rec {
  pname = "termtosvg";
  version = "1.1.0";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    sha256 = "1vk5kn8w3zf2ymi76l8cpwmvvavkmh3b9lb18xw3x1vzbmhz2f7d";
  };

  propagatedBuildInputs = with python3Packages; [ lxml pyte wcwidth ];

  meta = with lib; {
    homepage = "https://nbedos.github.io/termtosvg/";
    description = "Record terminal sessions as SVG animations";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
