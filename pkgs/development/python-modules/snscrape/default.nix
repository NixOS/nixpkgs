{
  lib,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  filelock,
  lxml,
  requests,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "snscrape";
  version = "0.7.0.20230622";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JustAnotherArchivist";
    repo = "snscrape";
    tag = "v${version}";
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
  ]
  ++ requests.optional-dependencies.socks;

  # There are no tests; make sure the executable works.
  checkPhase = ''
    export PATH=$PATH:$out/bin
    snscrape --help
  '';

  pythonImportsCheck = [ "snscrape" ];

  meta = {
    description = "Social networking service scraper";
    homepage = "https://github.com/JustAnotherArchivist/snscrape";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ivan ];
    mainProgram = "snscrape";
  };
}
