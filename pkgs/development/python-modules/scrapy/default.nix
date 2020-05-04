{ stdenv
, buildPythonPackage
, isPy27
, fetchPypi
, glibcLocales
, pytest
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
, lib
, jmespath
, sybil
, pytest-twisted
, botocore
}:

buildPythonPackage rec {
  version = "2.1.0";
  pname = "Scrapy";

  disabled = isPy27;

  checkInputs = [
    glibcLocales
    jmespath
    pytest
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
  ];

  patches = [
    # Scrapy is usually installed via pip where copying all
    # permissions makes sense. In Nix the files copied are owned by
    # root and readonly. As a consequence scrapy can't edit the
    # project templates.
    ./permissions-fix.patch
  ];

  LC_ALL = "en_US.UTF-8";

  # Disable doctest plugin—enabled in the shipped pytest.ini—because it causes pytest to hang
  # Ignore proxy tests because requires mitmproxy
  # Ignore test_retry_dns_error because tries to resolve an invalid dns and weirdly fails with "Reactor was unclean"
  # Ignore xml encoding test on darwin because lxml can't find encodings https://bugs.launchpad.net/lxml/+bug/707396
  checkPhase = ''
    substituteInPlace pytest.ini --replace "--doctest-modules" ""
    pytest --ignore=tests/test_linkextractors_deprecated.py --ignore=tests/test_proxy_connect.py --deselect tests/test_crawl.py::CrawlTestCase::test_retry_dns_error ${lib.optionalString stdenv.isDarwin "--deselect tests/test_utils_iterators.py::LxmlXmliterTestCase::test_xmliter_encoding"}
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "640aea0f9be9b055f5cfec5ab78ee88bb37a5be3809b138329bd2af51392ec7f";
  };

  postInstall = ''
    install -m 644 -D extras/scrapy.1 $out/share/man/man1/scrapy.1
    install -m 644 -D extras/scrapy_bash_completion $out/share/bash-completion/completions/scrapy
    install -m 644 -D extras/scrapy_zsh_completion $out/share/zsh/site-functions/_scrapy
  '';

  meta = with lib; {
    description = "A fast high-level web crawling and web scraping framework, used to crawl websites and extract structured data from their pages";
    homepage = "https://scrapy.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewkett marsam ];
    platforms = platforms.unix;
  };
}
