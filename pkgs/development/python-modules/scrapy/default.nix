{ stdenv, buildPythonPackage, fetchPypi, glibcLocales, mock, pytest, botocore,
  testfixtures, pillow, six, twisted, w3lib, lxml, queuelib, pyopenssl,
  service-identity, parsel, pydispatcher, cssselect, lib }:
buildPythonPackage rec {
  version = "1.5.1";
  pname = "Scrapy";

  checkInputs = [ glibcLocales mock pytest botocore testfixtures pillow ];
  propagatedBuildInputs = [
    six twisted w3lib lxml cssselect queuelib pyopenssl service-identity parsel pydispatcher
  ];

  # Scrapy is usually installed via pip where copying all
  # permissions makes sense. In Nix the files copied are owned by
  # root and readonly. As a consequence scrapy can't edit the
  # project templates.
  patches = [ ./permissions-fix.patch ];

  LC_ALL="en_US.UTF-8";

  checkPhase = ''
    py.test --ignore=tests/test_linkextractors_deprecated.py --ignore=tests/test_proxy_connect.py ${lib.optionalString stdenv.isDarwin "--ignore=tests/test_utils_iterators.py"}
    # The ignored tests require mitmproxy, which depends on protobuf, but it's disabled on Python3
    # Ignore iteration test, because lxml can't find encodings on darwin https://bugs.launchpad.net/lxml/+bug/707396
  '';

  src = fetchPypi {
    inherit pname version;
    sha256 = "5a398bf6818f87dcc817c919408a195f19ba46414ae12f259119336cfa862bb6";
  };

  meta = with lib; {
    description = "A fast high-level web crawling and web scraping framework, used to crawl websites and extract structured data from their pages";
    homepage = https://scrapy.org/;
    license = licenses.bsd3;
    maintainers = with maintainers; [ drewkett ];
    platforms = platforms.unix;
  };
}
