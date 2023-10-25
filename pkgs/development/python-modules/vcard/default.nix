{ buildPythonPackage
, fetchFromGitLab
, lib
, pytestCheckHook
, python-dateutil
, pythonAtLeast
, pythonOlder
}:
buildPythonPackage rec {
  pname = "vcard";
  version = "0.15.4";

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

  meta = {
    homepage = "https://gitlab.com/engmark/vcard";
    description = "vCard validator, class and utility functions";
    license = lib.licenses.agpl3Plus;
    maintainers = [ lib.maintainers.l0b0 ];
  };
}
