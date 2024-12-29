{
  lib,
  stdenv,
  botocore,
  buildPythonPackage,
  cryptography,
  cssselect,
  defusedxml,
  fetchFromGitHub,
  glibcLocales,
  installShellFiles,
  itemadapter,
  itemloaders,
  jmespath,
  lxml,
  packaging,
  parsel,
  pexpect,
  protego,
  pydispatcher,
  pyopenssl,
  pytest-xdist,
  pytestCheckHook,
  pythonOlder,
  queuelib,
  service-identity,
  setuptools,
  sybil,
  testfixtures,
  tldextract,
  twisted,
  uvloop,
  w3lib,
  zope-interface,
}:

buildPythonPackage rec {
  pname = "scrapy";
  version = "2.11.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "scrapy";
    repo = "scrapy";
    rev = "refs/tags/${version}";
    hash = "sha256-EaO1kQ3VSTwEW+r0kSKycOxHNTPwwCVjch1ZBrTU0qQ=";
  };

  pythonRelaxDeps = [
    "defusedxml"
  ];

  nativeBuildInputs = [
    installShellFiles
    setuptools
  ];

  propagatedBuildInputs = [
    cryptography
    cssselect
    defusedxml
    itemadapter
    itemloaders
    lxml
    packaging
    parsel
    protego
    pydispatcher
    pyopenssl
    queuelib
    service-identity
    tldextract
    twisted
    w3lib
    zope-interface
  ];

  nativeCheckInputs = [
    botocore
    glibcLocales
    jmespath
    pexpect
    pytest-xdist
    pytestCheckHook
    sybil
    testfixtures
    uvloop
  ];

  LC_ALL = "en_US.UTF-8";

  disabledTestPaths = [
    "tests/test_proxy_connect.py"
    "tests/test_utils_display.py"
    "tests/test_command_check.py"
    # Don't test the documentation
    "docs"
  ];

  disabledTests =
    [
      # Requires network access
      "AnonymousFTPTestCase"
      "FTPFeedStorageTest"
      "FeedExportTest"
      "test_custom_asyncio_loop_enabled_true"
      "test_custom_loop_asyncio"
      "test_custom_loop_asyncio_deferred_signal"
      "FileFeedStoragePreFeedOptionsTest" # https://github.com/scrapy/scrapy/issues/5157
      "test_persist"
      "test_timeout_download_from_spider_nodata_rcvd"
      "test_timeout_download_from_spider_server_hangs"
      "test_unbounded_response"
      "CookiesMiddlewareTest"
      # Test fails on Hydra
      "test_start_requests_laziness"
    ]
    ++ lib.optionals stdenv.isDarwin [
      "test_xmliter_encoding"
      "test_download"
      "test_reactor_default_twisted_reactor_select"
      "URIParamsSettingTest"
      "URIParamsFeedOptionTest"
      # flaky on darwin-aarch64
      "test_fixed_delay"
      "test_start_requests_laziness"
    ];

  postInstall = ''
    installManPage extras/scrapy.1
    installShellCompletion --cmd scrapy \
      --zsh extras/scrapy_zsh_completion \
      --bash extras/scrapy_bash_completion
  '';

  pythonImportsCheck = [ "scrapy" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "High-level web crawling and web scraping framework";
    mainProgram = "scrapy";
    longDescription = ''
      Scrapy is a fast high-level web crawling and web scraping framework, used to crawl
      websites and extract structured data from their pages. It can be used for a wide
      range of purposes, from data mining to monitoring and automated testing.
    '';
    homepage = "https://scrapy.org/";
    changelog = "https://github.com/scrapy/scrapy/raw/${version}/docs/news.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ vinnymeller ];
  };
}
