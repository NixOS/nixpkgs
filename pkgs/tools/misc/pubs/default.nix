{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pubs";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "pubs";
    repo = "pubs";
    rev = "v${version}";
    hash = "sha256-U/9MLqfXrzYVGttFSafw4pYDy26WgdsJMCxciZzO1pw=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    pyyaml
    bibtexparser
    python-dateutil
    six
    requests
    configobj
    beautifulsoup4
    feedparser
    argcomplete
  ];

  checkInputs = with python3.pkgs; [
    pyfakefs
    mock
    ddt
    pytestCheckHook
  ];

  disabledTestPaths = [
    # Disabling git tests because they expect git to be preconfigured
    # with the user's details. See
    # https://github.com/NixOS/nixpkgs/issues/94663
    "tests/test_git.py"
  ];

  disabledTests = [
    # https://github.com/pubs/pubs/issues/276
    "test_readme"
  ];

  meta = with lib; {
    description = "Command-line bibliography manager";
    homepage = "https://github.com/pubs/pubs";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ gebner dotlambda ];
  };
}
