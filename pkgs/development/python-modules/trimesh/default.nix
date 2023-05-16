{ lib
, buildPythonPackage
, fetchPypi
, setuptools
<<<<<<< HEAD
, pythonOlder
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, numpy
, lxml
}:

buildPythonPackage rec {
  pname = "trimesh";
<<<<<<< HEAD
  version = "3.23.5";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-vf1mnszEs/r/IyggCklAjNXsrZ8ZtgIsSttVS7s6JiE=";
=======
  version = "3.21.6";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+gFqZAbGLoNDdOmbxElKwb0QY7BJfOUZVD7888T6eU8=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [ numpy ];

  nativeCheckInputs = [ lxml ];

  checkPhase = ''
    # Disable test_load because requires loading models which aren't part of the tarball
    substituteInPlace tests/test_minimal.py --replace "test_load" "disable_test_load"
    python tests/test_minimal.py
  '';

  pythonImportsCheck = [ "trimesh" ];

  meta = with lib; {
    description = "Python library for loading and using triangular meshes";
    homepage = "https://trimsh.org/";
<<<<<<< HEAD
    changelog = "https://github.com/mikedh/trimesh/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ gebner ];
  };
}
