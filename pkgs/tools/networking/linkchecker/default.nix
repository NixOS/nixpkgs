{ lib
, stdenv
, fetchFromGitHub
, python3
, gettext
}:

python3.pkgs.buildPythonApplication rec {
  pname = "linkchecker";
  version = "10.4.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-2+zlVjkGFeozlJX/EZpGtmjxeB+1B8L3L68hfImKb2A=";
  };

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

  nativeCheckInputs = with python3.pkgs; [
    parameterized
    pytestCheckHook
  ];

  disabledTests = [
    # test_timeit2 is flakey, and depends sleep being precise to the milisecond
    "TestLoginUrl"
    "test_timeit2"
  ];

  disabledTestPaths = [
    "tests/test_linkchecker.py"
  ] ++ lib.optionals stdenv.isDarwin [
    "tests/checker/test_content_allows_robots.py"
    "tests/checker/test_http*.py"
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
