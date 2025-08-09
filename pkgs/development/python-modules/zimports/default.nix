{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  flake8-import-order,
  pyflakes,
  tomli,
  setuptools,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "zimports";
  version = "0.6.2";
  format = "setuptools";

  # upstream technically support 3.7 through 3.9, but 3.10 happens to work while 3.11 breaks with an import error
  disabled = pythonOlder "3.7" || pythonAtLeast "3.11";

  src = fetchFromGitHub {
    owner = "sqlalchemyorg";
    repo = "zimports";
    tag = "v${version}";
    hash = "sha256-yI/ZTNqVIu76xivXJ+MoLpPupf0RQjQOnP6OWMPajBo=";
  };

  propagatedBuildInputs = [
    flake8-import-order
    pyflakes
    setuptools
    tomli
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "zimports" ];

  meta = with lib; {
    description = "Python import rewriter";
    homepage = "https://github.com/sqlalchemyorg/zimports";
    license = licenses.mit;
    maintainers = with maintainers; [ timokau ];
  };
}
