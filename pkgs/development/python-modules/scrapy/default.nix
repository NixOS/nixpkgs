{ stdenv
, buildPythonPackage
, isPy27
, fetchPypi
, glibcLocales
, pytestCheckHook
, testfixtures
, pillow
, twisted
, cryptography
, w3lib
, lxml
, queuelib
, pyopenssl
, service-identity
, parsel
, pydispatcher
, cssselect
, zope_interface
, protego
, jmespath
, sybil
, pytest-twisted
, botocore
, itemadapter
, itemloaders
}:

buildPythonPackage rec {
  version = "2.4.0";
  pname = "Scrapy";

  disabled = isPy27;

  checkInputs = [
    glibcLocales
    jmespath
    pytestCheckHook
    sybil
    testfixtures
    pillow
    pytest-twisted
    botocore
  ];

  propagatedBuildInputs = [
    twisted
    cryptography
    cssselect
    lxml
    parsel
    pydispatcher
    pyopenssl
    queuelib
    service-identity
    w3lib
    zope_interface
    protego
    itemadapter
    itemloaders
  ];

  LC_ALL = "en_US.UTF-8";

  # Disable doctest plugin because it causes pytest to hang
  preCheck = ''
    substituteInPlace pytest.ini --replace "--doctest-modules" ""
  '';

  pytestFlagsArray = [
    "--ignore=tests/test_proxy_connect.py"
    "--ignore=tests/test_utils_display.py"
    "--ignore=tests/test_command_check.py"
  ];

  disabledTests = [
    "FTPFeedStorageTest"
    "test_noconnect"
    "test_retry_dns_error"
    "test_custom_asyncio_loop_enabled_true"
    "test_custom_loop_asyncio"
  ] ++ stdenv.lib.optionals stdenv.isDarwin [ "test_xmliter_encoding" ];

  src = fetchPypi {
    inherit pname version;
    sha256 = "4ea7fbc902ee0b0a79b154d07a5f4e747e2146f272a748557941946000728479";
  };

  postInstall = ''
    install -m 644 -D extras/scrapy.1 $out/share/man/man1/scrapy.1
    install -m 644 -D extras/scrapy_bash_completion $out/share/bash-completion/completions/scrapy
    install -m 644 -D extras/scrapy_zsh_completion $out/share/zsh/site-functions/_scrapy
  '';

  meta = with stdenv.lib; {
    description = "A fast high-level web crawling and web scraping framework, used to crawl websites and extract structured data from their pages";
    homepage = "https://scrapy.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewkett marsam ];
    platforms = platforms.unix;
  };
}
