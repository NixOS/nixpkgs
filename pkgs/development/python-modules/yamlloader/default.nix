{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pyyaml
, hypothesis
, pythonOlder
}:

buildPythonPackage rec {
  pname = "yamlloader";
<<<<<<< HEAD
  version = "1.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-fb2YQh2AkMUhZV8bBsoDAGfynfUlOoh4EmvOOpD1aBc=";
=======
  version = "1.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NWaf17n4xrONuGGlFwFULEJnK0boq2MlNIaoy4N3toc=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    pyyaml
  ];

  nativeCheckInputs = [
    hypothesis
    pytest
  ];

  pythonImportsCheck = [
    "yaml"
    "yamlloader"
  ];

  meta = with lib; {
    description = "A case-insensitive list for Python";
    homepage = "https://github.com/Phynix/yamlloader";
<<<<<<< HEAD
    changelog = "https://github.com/Phynix/yamlloader/releases/tag/${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ freezeboy ];
  };
}
