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
  hatchling,
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
  pyftpdlib,
  pyopenssl,
  pytest-asyncio,
  pytest-twisted,
  pytest-xdist,
  pytestCheckHook,
  pythonAtLeast,
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
  version = "2.14.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "scrapy";
    repo = "scrapy";
    tag = version;
    hash = "sha256-KDci1Z5TZ+3svotYXkEG1s+bPWtxzIfQQwOgvI0k8w0=";
  };

  pythonRelaxDeps = [
    "defusedxml"
  ];

  build-system = [
    hatchling
  ];

  nativeBuildInputs = [
    installShellFiles
    setuptools
  ];

  dependencies = [
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
    pytest-asyncio
    pytest-twisted
    pytest-xdist
    pyftpdlib
    pytestCheckHook
    sybil
    testfixtures
    uvloop
  ];

  env.LC_ALL = "en_US.UTF-8";

  pytestFlags = [
    # DeprecationWarning: There is no current event loop
    "-Wignore::DeprecationWarning"
  ];

  disabledTestPaths = [
    "tests/test_proxy_connect.py"
    "tests/test_utils_display.py"
    "tests/test_command_check.py"

    # ConnectionRefusedError: [Errno 111] Connection refused
    "tests/test_feedexport.py::TestFTPFeedStorage::test_append"
    "tests/test_feedexport.py::TestFTPFeedStorage::test_append_active_mode"
    "tests/test_feedexport.py::TestFTPFeedStorage::test_overwrite"
    "tests/test_feedexport.py::TestFTPFeedStorage::test_overwrite_active_mode"

    # this test is testing that the *first* deprecation warning is a specific one
    # but for some reason we get other deprecation warnings appearing first
    # but this isn't a material issue and the deprecation warning is still raised
    "tests/test_spider_start.py::MainTestCase::test_start_deprecated_super"

    # Don't test the documentation
    "docs"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    "tests/test_feedexport.py"
  ];

  disabledTests = [
    # Requires network access
    "AnonymousFTPTestCase"
    "FTPFeedStorageTest"
    "FeedExportTest"
    "test_custom_asyncio_loop_enabled_true"
    "test_custom_loop_asyncio"
    "test_custom_loop_asyncio_deferred_signal"
    # "FileFeedStoragePreFeedOptionsTest" # https://github.com/scrapy/scrapy/issues/5157
    "test_persist"
    "test_timeout_download_from_spider_nodata_rcvd"
    "test_timeout_download_from_spider_server_hangs"
    "test_unbounded_response"
    "CookiesMiddlewareTest"
    "test_asyncio_enabled_reactor_same_loop"
    "test_response_ip_address"
    # Test fails on Hydra
    "test_start_requests_laziness"

    # Fails due to different path structure on NixOS
    "test_start_deprecated_super"
    "test_file_path"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_xmliter_encoding"
    "test_download"
    "test_reactor_default_twisted_reactor_select"
    "URIParamsSettingTest"
    "URIParamsFeedOptionTest"
    # flaky on darwin-aarch64
    "test_fixed_delay"
    "test_start_requests_laziness"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    "test_non_pickable_object"
  ];

  postInstall = ''
    installManPage extras/scrapy.1
    installShellCompletion --cmd scrapy \
      --zsh extras/scrapy_zsh_completion \
      --bash extras/scrapy_bash_completion
  '';

  pythonImportsCheck = [ "scrapy" ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "High-level web crawling and web scraping framework";
    mainProgram = "scrapy";
    longDescription = ''
      Scrapy is a fast high-level web crawling and web scraping framework, used to crawl
      websites and extract structured data from their pages. It can be used for a wide
      range of purposes, from data mining to monitoring and automated testing.
    '';
    homepage = "https://scrapy.org/";
    changelog = "https://github.com/scrapy/scrapy/raw/${src.tag}/docs/news.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ vinnymeller ];
  };
}
