{ stdenv, lib, fetchFromGitHub, python3Packages, gettext }:

let
  pypkgs = python3Packages;

in
pypkgs.buildPythonApplication rec {
  pname = "linkchecker";
  version = "10.2.1";
  format = "pyproject";

  disabled = pypkgs.pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-z7Qp74cai8GfsxB4n9dSCWQepp0/4PimFiRJQBaVSoo=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [ gettext ];

  propagatedBuildInputs = with pypkgs; [
    argcomplete
    beautifulsoup4
    configargparse
    dnspython
    hatch-vcs
    hatchling
    pyopenssl
    requests
  ];

  checkInputs = with pypkgs; [
    parameterized
    pytest
  ];

  # test_timeit2 is flakey, and depends sleep being precise to the milisecond
  checkPhase = lib.optionalString stdenv.isDarwin ''
    # network tests fails on darwin
    rm tests/test_network.py tests/checker/test_http*.py tests/checker/test_content_allows_robots.py tests/checker/test_noproxy.py
  '' + ''
    pytest --ignore=tests/checker/{test_telnet,telnetserver}.py \
      -k 'not TestLoginUrl and not test_timeit2'
  '';

  meta = with lib; {
    description = "Check websites for broken links";
    homepage = "https://linkcheck.github.io/linkchecker/";
    changelog = "https://github.com/linkchecker/linkchecker/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg tweber ];
  };
}
