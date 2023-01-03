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
  version = "2.7.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit version;
    pname = "Scrapy";
    hash = "sha256-MPpAg1PSSx35ed8upK+9GbSuAvsiB/IY0kYzLx4c8U4=";
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

  checkInputs = [
    botocore
    glibcLocales
    jmespath
    pytestCheckHook
    sybil
    testfixtures
  ];

  LC_ALL = "en_US.UTF-8";

  preCheck = ''
    # Disable doctest plugin because it causes pytest to hang
    substituteInPlace pytest.ini \
      --replace "--doctest-modules" ""
  '';

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
  ] ++ lib.optionals stdenv.isDarwin [
    "test_xmliter_encoding"
    "test_download"
    "test_reactor_default_twisted_reactor_select"
  ];

  postInstall = ''
    installManPage extras/scrapy.1
    install -m 644 -D extras/scrapy_bash_completion $out/share/bash-completion/completions/scrapy
    install -m 644 -D extras/scrapy_zsh_completion $out/share/zsh/site-functions/_scrapy
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
    platforms = platforms.unix;
  };
}
