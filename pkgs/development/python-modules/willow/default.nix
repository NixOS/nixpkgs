{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
<<<<<<< HEAD

# dependencies
, filetype
, defusedxml,
=======
, six
, pillow
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "willow";
<<<<<<< HEAD
  version = "1.5.1";
  format = "setuptools";

=======
  version = "1.4.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  disabled = pythonOlder "2.7";

  src = fetchPypi {
    pname = "Willow";
    inherit version;
<<<<<<< HEAD
    hash = "sha256-t6SQkRATP9seIodZLgZzzCVeAobhzVNCfuaN8ckiDEw=";
  };

  propagatedBuildInputs = [
    filetype
    defusedxml
  ];
=======
    hash = "sha256-Dfj/UoUx4AtI1Av3Ltgb6sHcgvLULlu+1K/wIYvvjA0=";
  };

  propagatedBuildInputs = [ six pillow ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  # Test data is not included
  # https://github.com/torchbox/Willow/issues/34
  doCheck = false;

  meta = with lib; {
    description = "A Python image library that sits on top of Pillow, Wand and OpenCV";
    homepage = "https://github.com/torchbox/Willow/";
    license = licenses.bsd2;
    maintainers = with maintainers; [ desiderius ];
  };

}
