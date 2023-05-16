<<<<<<< HEAD
{ lib, python3Packages, fetchPypi }:
=======
{ lib, python3Packages }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

python3Packages.buildPythonPackage rec {
  pname = "rst2html5";
  version = "2.0";

<<<<<<< HEAD
  src = fetchPypi {
=======
  src = python3Packages.fetchPypi {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    inherit pname version;
    hash = "sha256-Ejjja/fm6wXTf9YtjCYZsNDB8X5oAtyPoUIsYFDuZfc=";
  };

  buildInputs = with python3Packages; [
    beautifulsoup4
    docutils
    genshi
    pygments
  ];

  meta = with lib;{
    homepage = "https://rst2html5.readthedocs.io/en/latest/";
    description = "Converts ReSTructuredText to (X)HTML5";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres ];
  };
}
