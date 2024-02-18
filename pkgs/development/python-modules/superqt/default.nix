{ lib
, buildPythonPackage
, fetchFromGitHub
, hatch-vcs
, hatchling
, packaging
, pygments
, pyqt5
, qtpy
, typing-extensions
}:

buildPythonPackage rec {
  pname = "superqt";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pyapp-kit";
    repo = "superqt";
    rev = "v${version}";
    hash = "sha256-kSu3QAr9GHmTkH9fyOuuI9UGSUgsYDUROOeQppXFQZg=";
  };

  nativeBuildInputs = [
    hatch-vcs
    hatchling
  ];

  propagatedBuildInputs = [
    pyqt5
    packaging
    pygments
    qtpy
    typing-extensions
  ];

  pythonImportsCheck = [ "superqt" ];

  meta = with lib; {
    description = "Missing widgets and components for Qt-python";
    homepage = "https://github.com/pyapp-kit/superqt";
    changelog = "https://github.com/pyapp-kit/superqt/blob/${src.rev}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
