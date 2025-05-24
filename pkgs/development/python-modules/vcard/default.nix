{
  lib,
  buildPythonPackage,
  fetchFromGitLab,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "vcard";
  version = "1.0.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitLab {
    owner = "engmark";
    repo = "vcard";
    tag = "v${version}";
    hash = "sha256-c6lj4sCXlQd5Bh5RLuZUIaTirVHtkRfYUAUtZI+1MeI=";
  };

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
