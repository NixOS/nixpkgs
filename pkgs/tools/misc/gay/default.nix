{ lib,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "gay";
  version = "1.2.9";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-x+RVVgQvJwV5j7DLYS7AnXb4OMJ4v+l0awUuonQIgzY=";
  };

  meta = with lib; {
    homepage = "https://github.com/ms-jpq/gay";
    description = "Colour your text / terminal to be more gay";
    license = licenses.mit;
    maintainers = with maintainers; [ AndersonTorres CodeLongAndProsper90 ];
  };
}
