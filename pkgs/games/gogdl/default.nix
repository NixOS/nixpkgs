{ lib
, gitUpdater
, buildPythonApplication
, fetchFromGitHub
, pythonOlder
, setuptools
, requests
}:

buildPythonApplication rec {
  pname = "gogdl";
  version = "0.4";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "Heroic-Games-Launcher";
    repo = "heroic-gogdl";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-4hWuGd0Alzd/ZqtN4zG2aid6C9lnT3Ihrrsjfg9PEYA=";
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

  passthru.updateScript = gitUpdater {
    rev-prefix = "v";
  };
}
