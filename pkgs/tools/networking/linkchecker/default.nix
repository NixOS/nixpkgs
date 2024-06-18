{ lib
, fetchFromGitHub
, python3
, gettext
}:

python3.pkgs.buildPythonApplication rec {
  pname = "linkchecker";
  version = "10.4.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "linkchecker";
    repo = "linkchecker";
    rev = "refs/tags/v${version}";
    hash = "sha256-2+zlVjkGFeozlJX/EZpGtmjxeB+1B8L3L68hfImKb2A=";
  };

  nativeBuildInputs = [ gettext ];

  build-system = with python3.pkgs; [
    hatchling
    hatch-vcs
    polib # translations
  ];

  dependencies = with python3.pkgs; [
    argcomplete
    beautifulsoup4
    dnspython
    requests
  ];

  nativeCheckInputs = with python3.pkgs; [
    pyopenssl
    parameterized
    pytestCheckHook
  ];

  disabledTests = [
    "TestLoginUrl"
    "test_timeit2" # flakey, and depends sleep being precise to the milisecond
    "test_internet" # uses network, fails on Darwin (not sure why it doesn't fail on linux)
  ];

  disabledTestPaths = [
    "tests/test_linkchecker.py"
  ] ++ lib.optionals stdenv.isDarwin [
    "tests/checker/test_content_allows_robots.py"
    "tests/checker/test_http*.py"
    "tests/test_network.py"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "Check websites for broken links";
    mainProgram = "linkchecker";
    homepage = "https://linkcheck.github.io/linkchecker/";
    changelog = "https://github.com/linkchecker/linkchecker/releases/tag/v${version}";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ peterhoeg tweber ];
  };
}
