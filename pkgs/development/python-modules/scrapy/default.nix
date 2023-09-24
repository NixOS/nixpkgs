{ lib
, stdenv
, botocore
, buildPythonPackage
, cryptography
, cssselect
, fetchPypi
, fetchpatch
, glibcLocales
, installShellFiles
, itemadapter
, itemloaders
, jmespath
, lxml
, packaging
, parsel
, protego
, pydispatcher
, pyopenssl
, pytestCheckHook
, pythonOlder
, queuelib
, service-identity
, sybil
, testfixtures
, tldextract
, twisted
, w3lib
, zope_interface
}:

buildPythonPackage rec {
  pname = "scrapy";
  version = "2.11.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit version;
    pname = "Scrapy";
    hash = "sha256-PL3tzgw/DgSC1hvi10WGg758188UsO5q37rduA9bNqU=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  propagatedBuildInputs = [
    cryptography
    cssselect
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
    zope_interface
  ];

  nativeCheckInputs = [
    botocore
    glibcLocales
    jmespath
    pytestCheckHook
    sybil
    testfixtures
  ];

  LC_ALL = "en_US.UTF-8";

  disabledTestPaths = [
    "tests/test_proxy_connect.py"
    "tests/test_utils_display.py"
    "tests/test_command_check.py"
    # Don't test the documentation
    "docs"
  ];

  disabledTests = [
    # It's unclear if the failures are related to libxml2, https://github.com/NixOS/nixpkgs/pull/123890
    "test_nested_css"
    "test_nested_xpath"
    "test_flavor_detection"
    "test_follow_whitespace"
    # Requires network access
    "AnonymousFTPTestCase"
    "FTPFeedStorageTest"
    "FeedExportTest"
    "test_custom_asyncio_loop_enabled_true"
    "test_custom_loop_asyncio"
    "test_custom_loop_asyncio_deferred_signal"
    "FileFeedStoragePreFeedOptionsTest"  # https://github.com/scrapy/scrapy/issues/5157
    "test_persist"
    "test_timeout_download_from_spider_nodata_rcvd"
    "test_timeout_download_from_spider_server_hangs"
    # Depends on uvloop
    "test_asyncio_enabled_reactor_different_loop"
    "test_asyncio_enabled_reactor_same_loop"
    # Fails with AssertionError
    "test_peek_fifo"
    "test_peek_one_element"
    "test_peek_lifo"
    "test_callback_kwargs"
    # Test fails on Hydra
    "test_start_requests_laziness"
  ] ++ lib.optionals stdenv.isDarwin [
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

  pythonImportsCheck = [
    "scrapy"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "High-level web crawling and web scraping framework";
    longDescription = ''
      Scrapy is a fast high-level web crawling and web scraping framework, used to crawl
      websites and extract structured data from their pages. It can be used for a wide
      range of purposes, from data mining to monitoring and automated testing.
    '';
    homepage = "https://scrapy.org/";
    changelog = "https://github.com/scrapy/scrapy/raw/${version}/docs/news.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ marsam ];
  };
}
