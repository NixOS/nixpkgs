{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  pytestCheckHook,
  python-dateutil,
  pythonAtLeast,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "vcard";
  version = "0.16.1";
  pyproject = true;

  disabled = pythonOlder "3.8" || pythonAtLeast "3.12";

  src = fetchFromGitLab {
    owner = "engmark";
    repo = "vcard";
    rev = "refs/tags/v${version}";
    hash = "sha256-cz1WF8LQsyJwcVKMSWmFb6OB/JWyfc2FgcOT3jJ45Cg=";
  };

  pythonRelaxDeps = [ "python-dateutil" ];

  build-system = [ setuptools ];

  dependencies = [ python-dateutil ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "vcard" ];

  meta = {
    description = "vCard validator, class and utility functions";
    longDescription = ''
      This program can be used for strict validation and parsing of vCards. It currently supports vCard 3.0 (RFC 2426).
    '';
    homepage = "https://gitlab.com/engmark/vcard";
    license = lib.licenses.agpl3Plus;
    mainProgram = "vcard";
    maintainers = with lib.maintainers; [ l0b0 ];
  };
}
