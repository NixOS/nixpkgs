{ lib, python3, fetchPypi }:

with python3.pkgs;

buildPythonApplication rec {
  pname = "chkcrontab";
  version = "1.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-VoZ5Q3SRCxRnBMLWYMtZL6EyL3PFseSe9nJPOeVWvT4=";
  };

  meta = with lib; {
    description = "Tool to detect crontab errors";
    mainProgram = "chkcrontab";
    license = licenses.asl20;
    maintainers = with maintainers; [ ];
    homepage = "https://github.com/lyda/chkcrontab";
  };
}
