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
  version = "0.4.3.20220106";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "JustAnotherArchivist";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gphNT1IYSiAw22sqHlV8Rm4WRP4EWUvP0UkITuepmMc=";
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
