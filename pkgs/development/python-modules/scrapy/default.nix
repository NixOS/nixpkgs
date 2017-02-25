{ buildPythonPackage, fetchurl, glibcLocales, mock, pytest, botocore,
  testfixtures, pillow, six, twisted, w3lib, lxml, queuelib, pyopenssl,
  service-identity, parsel, pydispatcher, cssselect, lib }:
buildPythonPackage rec {
    name = "Scrapy-${version}";
    version = "1.3.1";

    buildInputs = [ glibcLocales mock pytest botocore testfixtures pillow ];
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
      py.test --ignore=tests/test_linkextractors_deprecated.py --ignore=tests/test_proxy_connect.py
      # The ignored tests require mitmproxy, which depends on protobuf, but it's disabled on Python3
    '';

    src = fetchurl {
      url = "mirror://pypi/S/Scrapy/${name}.tar.gz";
      sha256 = "0s5qkxwfq842maxjd2j82ldp4dyb70kla3z5rr56z0p7ig53cbvk";
    };

    meta = with lib; {
      description = "A fast high-level web crawling and web scraping framework, used to crawl websites and extract structured data from their pages";
      homepage = "http://scrapy.org/";
      license = licenses.bsd3;
      maintainers = with maintainers; [ drewkett ];
      platforms = platforms.linux;
    };
}
