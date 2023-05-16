{ lib
, buildPythonPackage
, fetchPypi
<<<<<<< HEAD
, pytestCheckHook
, pythonOlder
=======
, glibcLocales
, pytest
, mock
, ipython_genutils
, decorator
, pythonOlder
, six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, hatchling
}:

buildPythonPackage rec {
  pname = "traitlets";
  version = "5.9.0";
  format = "pyproject";
  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9s3iGpxoz3Vq8CA19y1acjv2B+hi574z7OUFq/Sjutk=";
  };

  nativeBuildInputs = [ hatchling ];
<<<<<<< HEAD

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "Traitlets Python config system";
    homepage = "https://github.com/ipython/traitlets";
=======
  nativeCheckInputs = [ glibcLocales pytest mock ];
  propagatedBuildInputs = [ ipython_genutils decorator six ];

  checkPhase = ''
    LC_ALL="en_US.UTF-8" py.test
  '';

  meta = {
    description = "Traitlets Python config system";
    homepage = "https://ipython.org/";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ fridh ];
  };
}
