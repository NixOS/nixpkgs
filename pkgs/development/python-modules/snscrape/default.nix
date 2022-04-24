{ lib
, beautifulsoup4
, buildPythonPackage
, fetchFromGitHub
, lxml
, pythonOlder
, pytz
, requests
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "snscrape";
  version = "unstable-2021-08-30";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "JustAnotherArchivist";
    repo = pname;
    rev = "c76f1637ce1d7a154af83495b67ead2559cd5715";
    sha256 = "01x4961fxj1p98y6fcyxw5sv8fa87x41fdx9p31is12bdkmqxi6v";
  };

  SETUPTOOLS_SCM_PRETEND_VERSION = version;

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    beautifulsoup4
    lxml
    requests
  ] ++ lib.optionals (pythonOlder "3.9") [
    pytz
  ];

  # There are no tests; make sure the executable works.
  checkPhase = ''
    export PATH=$PATH:$out/bin
    snscrape --help
  '';

  pythonImportsCheck = [ "snscrape" ];

  meta = with lib; {
    homepage = "https://github.com/JustAnotherArchivist/snscrape";
    description = "A social networking service scraper in Python";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ivan ];
  };
}
