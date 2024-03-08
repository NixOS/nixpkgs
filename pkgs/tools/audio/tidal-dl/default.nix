{ lib
, buildPythonApplication
, fetchPypi
, aigpy
}:

buildPythonApplication rec {
  pname = "tidal-dl";
  version = "2022.10.31.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-b2AAsiI3n2/v6HC37fMI/d8UcxZxsWM+fnWvdajHrOg=";
  };

  propagatedBuildInputs = [ aigpy ];

  meta = {
    homepage = "https://github.com/yaronzz/Tidal-Media-Downloader";
    description = "An application that lets you download videos and tracks from Tidal";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.misterio77 ];
    platforms = lib.platforms.all;
    mainProgram = "tidal-dl";
  };
}
