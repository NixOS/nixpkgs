{ lib
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, filelock
, lxml
, pythonOlder
, pytz
, requests
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "snscrape";
  version = "0.6.0.20230303";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "JustAnotherArchivist";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-FY8byS+0yAhNSRxWsrsQMR5kdZmnHutru5Z6SWVfpiE=";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    filelock
    lxml
    requests
  ]
  ++ requests.optional-dependencies.socks
  ++ lib.optionals (pythonOlder "3.9") [
    pytz
  ];

  # There are no tests; make sure the executable works.
  checkPhase = ''
    export PATH=$PATH:$out/bin
    snscrape --help
  '';

  pythonImportsCheck = [
    "snscrape"
  ];

  meta = with lib; {
    description = "A social networking service scraper";
    homepage = "https://github.com/JustAnotherArchivist/snscrape";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ivan ];
  };
}
