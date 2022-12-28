{ lib
, fetchFromGitHub
, fetchpatch
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

  patches = [
    # https://github.com/pubs/pubs/pull/278
    (fetchpatch {
      url = "https://github.com/pubs/pubs/commit/9623d2c3ca8ff6d2bb7f6c8d8624f9a174d831bc.patch";
      hash = "sha256-6qoufKPv3k6C9BQTZ2/175Nk7zWPh89vG+zebx6ZFOk=";
    })
    # https://github.com/pubs/pubs/pull/279
    (fetchpatch {
      url = "https://github.com/pubs/pubs/commit/05e214eb406447196c77c8aa3e4658f70e505f23.patch";
      hash = "sha256-UBkKiYaG6y6z8lsRpdcsaGsoklv6qj07KWdfkQcVl2g=";
    })
  ];

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
