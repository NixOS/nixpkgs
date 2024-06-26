{ lib
, python3
, fetchPypi
}:

with python3.pkgs;

buildPythonPackage rec {
  pname = "wlc";
  version = "1.14";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-QMF41B6a2jMSdhjeFoRQq+K1YJAEz96msHLzX6wVqSc=";
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
    description = "Weblate commandline client using Weblate's REST API";
    homepage = "https://github.com/WeblateOrg/wlc";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ paperdigits ];
    mainProgram = "wlc";
  };
}
