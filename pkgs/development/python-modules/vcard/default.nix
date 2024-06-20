{
  buildPythonPackage,
  fetchFromGitLab,
  lib,
  nix-update-script,
  pytestCheckHook,
  python-dateutil,
  pythonAtLeast,
  pythonOlder,
}:
let
  version = "0.15.4";
in
buildPythonPackage {
  inherit version;

  pname = "vcard";
  format = "setuptools";

  disabled = pythonOlder "3.8" || pythonAtLeast "3.12";

  src = fetchFromGitLab {
    owner = "engmark";
    repo = "vcard";
    rev = "refs/tags/v${version}";
    hash = "sha256-7GNq6PoWZgwhhpxhWOkUEpqckeSfzocex1ZGN9CTJyo=";
  };

  propagatedBuildInputs = [ python-dateutil ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "vcard" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    homepage = "https://gitlab.com/engmark/vcard";
    description = "vCard validator, class and utility functions";
    longDescription = ''
      This program can be used for strict validation and parsing of vCards. It currently supports vCard 3.0 (RFC 2426).
    '';
    license = lib.licenses.agpl3Plus;
    mainProgram = "vcard";
    maintainers = [ lib.maintainers.l0b0 ];
  };
}
