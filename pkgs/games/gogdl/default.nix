{ lib
, fetchpatch
, writeScript
, buildPythonApplication
, fetchFromGitHub
, pythonOlder
, setuptools
, requests
, cacert
, unstableGitUpdater
}:

buildPythonApplication rec {
  pname = "gogdl";
  version = "unstable-2024-02-15";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Heroic-Games-Launcher";
    repo = "heroic-gogdl";
    rev = "18f651931d4098cba66f4c2a2f9dc6e1351f9460";
    hash = "sha256-wGytOzMencWZIku5lM6gEFaFyqUtfurjZVSHAY5mI7g=";
  };

  disabled = pythonOlder "3.8";

  propagatedBuildInputs = [
    setuptools
    requests
  ];

  pythonImportsCheck = [ "gogdl" ];

  meta = with lib; {
    description = "GOG Downloading module for Heroic Games Launcher";
    homepage = "https://github.com/Heroic-Games-Launcher/heroic-gogdl";
    license = with licenses; [ gpl3 ];
    maintainers = with maintainers; [ aidalgol ];
  };

  # Upstream no longer create git tags when bumping the version, so we have to
  # extract it from the source code on the main branch.
  passthru.updateScript = unstableGitUpdater { };
}
