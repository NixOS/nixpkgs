{ stdenv, buildPythonPackage, fetchPypi, glibcLocales, mock, pytest, botocore,
  testfixtures, pillow, six, twisted, w3lib, lxml, queuelib, pyopenssl,
  service-identity, parsel, pydispatcher, cssselect, lib, fetchpatch }:
buildPythonPackage rec {
  version = "1.5.1";
  pname = "Scrapy";

  checkInputs = [ glibcLocales mock pytest botocore testfixtures pillow ];
  propagatedBuildInputs = [
    six twisted w3lib lxml cssselect queuelib pyopenssl service-identity parsel pydispatcher
  ];

  patches = [
    # Scrapy is usually installed via pip where copying all
    # permissions makes sense. In Nix the files copied are owned by
    # root and readonly. As a consequence scrapy can't edit the
    # project templates.
    ./permissions-fix.patch
    # fix python37 issues. Remove with the next release
    (fetchpatch {
      url = https://github.com/scrapy/scrapy/commit/f4f39057cbbfa4daf66f82061e57101b88d88d05.patch;
      sha256 = "1f761qkji362i20i5bzcxz44sihvl29prm02i5l2xyhgl1hp91hv";
    })
  ];

  LC_ALL="en_US.UTF-8";

  # Ignore proxy tests because requires mitmproxy
  # Ignore test_retry_dns_error because tries to resolve an invalid dns and weirdly fails with "Reactor was unclean"
  # Ignore xml encoding test on darwin because lxml can't find encodings https://bugs.launchpad.net/lxml/+bug/707396
  checkPhase = ''
    pytest --ignore=tests/test_linkextractors_deprecated.py --ignore=tests/test_proxy_connect.py --deselect tests/test_crawl.py::CrawlTestCase::test_retry_dns_error ${lib.optionalString stdenv.isDarwin "--deselect tests/test_utils_iterators.py::LxmlXmliterTestCase::test_xmliter_encoding"}
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a398bf6818f87dcc817c919408a195f19ba46414ae12f259119336cfa862bb6";
  };

  postInstall = ''
    install -m 644 -D extras/scrapy.1 $out/share/man/man1/scrapy.1
    install -m 644 -D extras/scrapy_bash_completion $out/share/bash-completion/completions/scrapy
    install -m 644 -D extras/scrapy_zsh_completion $out/share/zsh/site-functions/_scrapy
  '';

  meta = with lib; {
    description = "A fast high-level web crawling and web scraping framework, used to crawl websites and extract structured data from their pages";
    homepage = https://scrapy.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewkett marsam ];
    platforms = platforms.unix;
  };
}
