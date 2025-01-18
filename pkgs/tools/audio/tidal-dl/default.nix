{
  lib,
  buildPythonApplication,
  fetchPypi,
  aigpy,
}:

buildPythonApplication rec {
  pname = "tidal-dl";
  version = "2022.10.31.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-b2AAsiI3n2/v6HC37fMI/d8UcxZxsWM+fnWvdajHrOg=";
  };

  propagatedBuildInputs = [ aigpy ];

  meta = with lib; {
    homepage = "https://github.com/yaronzz/Tidal-Media-Downloader";
    description = "Application that lets you download videos and tracks from Tidal";
    license = licenses.asl20;
    maintainers = [ maintainers.misterio77 ];
    platforms = platforms.all;
    mainProgram = "tidal-dl";
  };
}
