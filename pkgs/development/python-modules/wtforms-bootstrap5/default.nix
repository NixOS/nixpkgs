{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  wtforms,
  poetry-core,
  pytestCheckHook,
  lxml,
}:

buildPythonPackage (finalAttrs: {
  pname = "wtforms-bootstrap5";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "LaunchPlatform";
    repo = "wtforms-bootstrap5";
    rev = finalAttrs.version;
    hash = "sha256-TJJ3KOeC9JXnxK0YpnfeBNq1KHwaAZ4+t9CXbc+85Ro=";
  };

  nativeBuildInputs = [ poetry-core ];

  propagatedBuildInputs = [ wtforms ];

  nativeCheckInputs = [
    pytestCheckHook
    lxml
  ];

  meta = {
    description = "Simple library for rendering WTForms in HTML as Bootstrap 5 form controls";
    homepage = "https://github.com/LaunchPlatform/wtforms-bootstrap5";
    changelog = "https://github.com/LaunchPlatform/wtforms-bootstrap5/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
  };
})
