{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pint,
  pygments,
  pyqt5,
  pyqt6,
  pyside2,
  pyside6,
  pytestCheckHook,
  pythonOlder,
  qtpy,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "superqt";
<<<<<<< HEAD
  version = "0.7.7";
=======
  version = "0.7.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "pyapp-kit";
    repo = "superqt";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-l6O3qI1mkaqiQAVL2jIf/ylRntsqa5p2x+ojV1ZdAtE=";
=======
    hash = "sha256-Hdi1aTMZeQqaqeK7B4yynTOBc6Cy1QcX5BHsr6g1xwM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    pygments
    pyqt5
    qtpy
    typing-extensions
  ];

  optional-dependencies = {
    quantity = [ pint ];
    pyside2 = [ pyside2 ];
    pyside6 = [ pyside6 ];
    pyqt6 = [ pyqt6 ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  # Segmentation fault
  doCheck = false;

  # Segmentation fault
  # pythonImportsCheck = [ "superqt" ];

<<<<<<< HEAD
  meta = {
    description = "Missing widgets and components for Qt-python (napari/superqt)";
    homepage = "https://github.com/napari/superqt";
    changelog = "https://github.com/pyapp-kit/superqt/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
=======
  meta = with lib; {
    description = "Missing widgets and components for Qt-python (napari/superqt)";
    homepage = "https://github.com/napari/superqt";
    changelog = "https://github.com/pyapp-kit/superqt/releases/tag/${src.tag}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
