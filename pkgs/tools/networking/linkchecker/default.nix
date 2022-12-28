{ lib
, stdenv
, fetchFromGitHub
, python3
, gettext
}:

python3.pkgs.buildPythonApplication rec {
  pname = "linkchecker";
  version = "10.2.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-z7Qp74cai8GfsxB4n9dSCWQepp0/4PimFiRJQBaVSoo=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    gettext
  ];

  propagatedBuildInputs = with python3.pkgs; [
    argcomplete
    beautifulsoup4
    configargparse
    dnspython
    hatch-vcs
    hatchling
    pyopenssl
    requests
  ];

  checkInputs = with python3.pkgs; [
    parameterized
    pytestCheckHook
  ];

  disabledTests = [
    # test_timeit2 is flakey, and depends sleep being precise to the milisecond
    "TestLoginUrl"
    "test_timeit2"
  ];

  disabledTestPaths = [
    "tests/checker/telnetserver.py"
    "tests/checker/test_telnet.py"
  ] ++ lib.optionals stdenv.isDarwin [
    "tests/checker/test_content_allows_robots.py"
    "tests/checker/test_http*.py"
    "tests/checker/test_noproxy.py"
    "tests/test_network.py"
  ];

  meta = with lib; {
    description = "Check websites for broken links";
    homepage = "https://linkcheck.github.io/linkchecker/";
    changelog = "https://github.com/linkchecker/linkchecker/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg tweber ];
  };
}
