{ lib
, buildPythonApplication
, fetchFromGitLab
, python-musicpd
, requests}:

buildPythonApplication rec {
  pname = "mpd-sima";
  version = "0.18.2";

  src = fetchFromGitLab {
    owner = "kaliko";
    repo = "sima";
     rev = version;
    hash = "sha256-lMvM1EqS1govhv4B2hJzIg5DFQYgEr4yJJtgOQxnVlY=";
  };

  format = "setuptools";

  propagatedBuildInputs = [
    requests
    python-musicpd
  ];

  doCheck = true;

  preCheck = ''
    export HOME="$(mktemp -d)"
  '';

  meta = with lib; {
    description = "Autoqueuing mpd client";
    homepage = "https://kaliko.me/mpd-sima/";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with lib.maintainers; [ apfelkuchen6 ];
    mainProgram = "mpd-sima";
  };
}
