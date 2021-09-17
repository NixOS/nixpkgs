{ lib
, stdenv
, botocore
, buildPythonPackage
, cryptography
, cssselect
, fetchFromGitHub
, fetchpatch
, glibcLocales
, installShellFiles
, itemadapter
, itemloaders
, jmespath
, lxml
, parsel
, pillow
, protego
, pydispatcher
, pyopenssl
, pytest-twisted
, pytestCheckHook
, pythonOlder
, queuelib
, service-identity
, sybil
, testfixtures
, twisted
, w3lib
, zope_interface
}:

buildPythonPackage rec {
  pname = "scrapy";
  version = "2.5.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = version;
    sha256 = "09lxnjz1cw37i9bgk8sci2xxknj20gi2lq8l7i0b3xw7q8bxzp7h";
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
    parsel
    protego
    pydispatcher
    pyopenssl
    queuelib
    service-identity
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

  patches = [
    # Require setuptools, https://github.com/scrapy/scrapy/pull/5122
    (fetchpatch {
      name = "add-setuptools.patch";
      url = "https://github.com/scrapy/scrapy/commit/4f500342c8ad4674b191e1fab0d1b2ac944d7d3e.patch";
      sha256 = "14030sfv1cf7dy4yww02b49mg39cfcg4bv7ys1iwycfqag3xcjda";
    })
    # Make Twisted[http2] installation optional, https://github.com/scrapy/scrapy/pull/5113
    (fetchpatch {
      name = "remove-h2.patch";
      url = "https://github.com/scrapy/scrapy/commit/c5b1ee810167266fcd259f263dbfc0fe0204761a.patch";
      sha256 = "1gw28wg8qcb0al59rz214hm17smspi6j5kg62nr1r850pykyrsqk";
    })
  ];

  LC_ALL = "en_US.UTF-8";

  # Disable doctest plugin because it causes pytest to hang
  preCheck = ''
    substituteInPlace pytest.ini --replace "--doctest-modules" ""
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
    # Requires network access
    "FTPFeedStorageTest"
    "FeedExportTest"
    "test_custom_asyncio_loop_enabled_true"
    "test_custom_loop_asyncio"
    "test_custom_loop_asyncio_deferred_signal"
    "FileFeedStoragePreFeedOptionsTest"  # https://github.com/scrapy/scrapy/issues/5157
    # Fails with AssertionError
    "test_peek_fifo"
    "test_peek_one_element"
    "test_peek_lifo"
  ] ++ lib.optionals stdenv.isDarwin [
    "test_xmliter_encoding"
    "test_download"
  ];

  postInstall = ''
    installManPage extras/scrapy.1
    install -m 644 -D extras/scrapy_bash_completion $out/share/bash-completion/completions/scrapy
    install -m 644 -D extras/scrapy_zsh_completion $out/share/zsh/site-functions/_scrapy
  '';

  pythonImportsCheck = [ "scrapy" ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "High-level web crawling and web scraping framework";
    longDescription = ''
      Scrapy is a fast high-level web crawling and web scraping framework, used to crawl
      websites and extract structured data from their pages. It can be used for a wide
      range of purposes, from data mining to monitoring and automated testing.
    '';
    homepage = "https://scrapy.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewkett marsam ];
    platforms = platforms.unix;
  };
}
