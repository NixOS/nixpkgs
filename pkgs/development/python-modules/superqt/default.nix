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
  version = "0.6.7";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "pyapp-kit";
    repo = "superqt";
    rev = "refs/tags/v${version}";
    hash = "sha256-/VR9Lc1x+7J/3zyo/eBFBvGkPXzpTfPpNAvNhSzWio8=";
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

  passthru.optional-dependencies = {
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

  meta = with lib; {
    description = "Missing widgets and components for Qt-python (napari/superqt)";
    homepage = "https://github.com/napari/superqt";
    changelog = "https://github.com/pyapp-kit/superqt/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
