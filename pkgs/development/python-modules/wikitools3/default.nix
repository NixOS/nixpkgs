{ lib
, python3
, fetchPypi
}:

python3.pkgs.buildPythonPackage rec {
  pname = "wikitools3";
  version = "3.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-tJPmgG+xmFrRrylMVjZK66bqZ6NmVTvBG2W39SedABI=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    poster3
  ];

  pythonImportsCheck = [ "wikitools3" ];

  meta = with lib; {
    description = "Python package for interacting with a MediaWiki wiki. It is used by WikiTeam for archiving MediaWiki wikis";
    homepage = "https://pypi.org/project/wikitools3";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ TheBrainScrambler ];
  };
}
