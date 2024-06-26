{ lib
, buildPythonApplication
, fetchFromGitHub
, bencoder
, pyyaml
, requests
}:
buildPythonApplication rec {
  pname = "gazelle-origin";
  version = "3.0.0";
  format = "setuptools";

  src = fetchFromGitHub {
    repo = pname;
    # Use the spinfast319 fork, since it seems that upstream
    # at <https://github.com/x1ppy/gazelle-origin> is inactive
    owner = "spinfast319";
    rev = version;
    hash = "sha256-+yMKnfG2f+A1/MxSBFLaHfpCgI2m968iXqt+2QanM/c=";
  };

  propagatedBuildInputs = [
    bencoder
    pyyaml
    requests
  ];

  pythonImportsCheck = [ "gazelleorigin" ];

  meta = with lib; {
    description = "Tool for generating origin files using the API of Gazelle-based torrent trackers";
    homepage = "https://github.com/spinfast319/gazelle-origin";
    # TODO license is unspecified in the upstream, as well as the fork
    license = licenses.unfree;
    maintainers = with maintainers; [ somasis ];
    mainProgram = "gazelle-origin";
  };
}
