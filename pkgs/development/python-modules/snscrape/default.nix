{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  filelock,
  lxml,
  pythonOlder,
  pytz,
  requests,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "snscrape";
  version = "0.7.0.20230622";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "JustAnotherArchivist";
    repo = "snscrape";
    rev = "refs/tags/v${version}";
    hash = "sha256-9xAUMr1SWFePEvIz6DFEexk9Txex3u8wPNfMAdxEUCA=";
  };

  patches = [
    # Fix find_module deprecation, https://github.com/JustAnotherArchivist/snscrape/pull/1036
    (fetchpatch {
      name = "fix-find-module.patch";
      url = "https://github.com/JustAnotherArchivist/snscrape/commit/7f4717aaaaa8d4c96fa1dbe72ded799a722732ee.patch";
      hash = "sha256-6O9bZ5GlTPuR0MML/O4DDRBcDX/CJbU54ZE551cfPHo=";
    })
  ];

  build-system = [ setuptools-scm ];

  dependencies = [
    beautifulsoup4
    filelock
    lxml
    requests
  ] ++ requests.optional-dependencies.socks ++ lib.optionals (pythonOlder "3.9") [ pytz ];

  # There are no tests; make sure the executable works.
  checkPhase = ''
    export PATH=$PATH:$out/bin
    snscrape --help
  '';

  pythonImportsCheck = [ "snscrape" ];

  meta = with lib; {
    description = "Social networking service scraper";
    homepage = "https://github.com/JustAnotherArchivist/snscrape";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ivan ];
    mainProgram = "snscrape";
  };
}
