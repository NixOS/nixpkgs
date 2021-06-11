{ lib
, python3
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "wlc";
  version = "1.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256:0ysx250v2qycy1m3jj0wxmyf2f5n8fxf6br69vcbyq2cnqw609nx";
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
