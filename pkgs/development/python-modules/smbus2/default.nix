{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
<<<<<<< HEAD
  setuptools,
=======
  pythonOlder,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
}:

buildPythonPackage rec {
  pname = "smbus2";
<<<<<<< HEAD
  version = "0.6.0";
  pyproject = true;
=======
  version = "0.5.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "kplindegaard";
    repo = "smbus2";
    tag = version;
<<<<<<< HEAD
    hash = "sha256-GoXSDUmMnrJAfQ8EfCP5bdkq5g0nKLRHcvou5c6vZGU=";
  };

  build-system = [ setuptools ];

=======
    hash = "sha256-3ZAjviVLO/c27NzrPcWf6RlZYclYkmUmOskTP9TVbNM=";
  };

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "smbus2" ];

<<<<<<< HEAD
  meta = {
    description = "Drop-in replacement for smbus-cffi/smbus-python";
    homepage = "https://smbus2.readthedocs.io/";
    changelog = "https://github.com/kplindegaard/smbus2/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
=======
  meta = with lib; {
    description = "Drop-in replacement for smbus-cffi/smbus-python";
    homepage = "https://smbus2.readthedocs.io/";
    changelog = "https://github.com/kplindegaard/smbus2/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
