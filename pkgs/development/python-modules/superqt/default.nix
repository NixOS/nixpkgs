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
  qtpy,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "superqt";
  version = "0.7.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyapp-kit";
    repo = "superqt";
    tag = "v${version}";
    hash = "sha256-ipDtwymKocCRwcW/eYpM6jrmrjkYQJlaEyaSV4SinMM=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    pygments
    qtpy
    typing-extensions
  ];

  optional-dependencies = {
    quantity = [ pint ];
    pyside2 = [ pyside2 ];
    pyside6 = [ pyside6 ];
    pyqt6 = [ pyqt6 ];
    pyqt5 = [ pyqt5 ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  # Segmentation fault
  doCheck = false;

  # Segmentation fault
  # pythonImportsCheck = [ "superqt" ];

  meta = {
    description = "Missing widgets and components for Qt-python (napari/superqt)";
    homepage = "https://github.com/napari/superqt";
    changelog = "https://github.com/pyapp-kit/superqt/releases/tag/${src.tag}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ SomeoneSerge ];
  };
}
