{ lib
, python3
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "wlc";
  version = "1.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256:01c1qxq6dxvpn8rgpbqs4iw5daa0rmlgygb3xhhfj7xpqv1v84ir";
  };

  propagatedBuildInputs = [
    argcomplete
    python-dateutil
    requests
    pyxdg
    pre-commit
    responses
    twine
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "wlc is a Weblate commandline client using Weblate's REST API.";
    homepage = "https://github.com/WeblateOrg/wlc";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ paperdigits ];
  };
}
