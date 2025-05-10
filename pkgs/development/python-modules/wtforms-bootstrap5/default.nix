{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  wtforms,
  poetry-core,
  pytestCheckHook,
  lxml,
}:

buildPythonPackage rec {
  pname = "wtforms-bootstrap5";
  version = "0.3.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "wtforms-bootstrap5";
    rev = version;
    hash = "sha256-TJJ3KOeC9JXnxK0YpnfeBNq1KHwaAZ4+t9CXbc+85Ro=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ wtforms ];

  nativeCheckInputs = [
    pytestCheckHook
    lxml
  ];

  meta = with lib; {
    description = "Simple library for rendering WTForms in HTML as Bootstrap 5 form controls";
    homepage = "https://github.com/LaunchPlatform/wtforms-bootstrap5";
    changelog = "https://github.com/LaunchPlatform/wtforms-bootstrap5/releases/tag/${version}";
    license = licenses.mit;
    teams = [ teams.wdz ];
  };
}
