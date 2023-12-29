{ lib
, python3
, fetchPypi
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "wlc";
  version = "1.13";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MZ6avuMNT5HIIXW7ezukAJeO70o+SrgJnBnGjNy4tYE=";
  };

  propagatedBuildInputs = [
    argcomplete
    python-dateutil
    requests
    pyxdg
    responses
    twine
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "wlc is a Weblate commandline client using Weblate's REST API.";
    homepage = "https://github.com/WeblateOrg/wlc";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ paperdigits ];
    mainProgram = "wlc";
  };
}
