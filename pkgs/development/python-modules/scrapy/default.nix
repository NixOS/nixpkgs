{ buildPythonPackage, fetchurl, glibcLocales, mock, pytest, botocore,
  testfixtures, pillow, six, twisted, w3lib, lxml, queuelib, pyopenssl,
  service-identity, parsel, pydispatcher, cssselect, lib }:
buildPythonPackage rec {
    version = "1.4.0";
    pname = "Scrapy";
    name = "${pname}-${version}";

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
      sha256 = "04a08f027eef5d271342a016439533c81ba46f14bfcf230fecf602e99beaf233";
    };

    meta = with lib; {
      description = "A fast high-level web crawling and web scraping framework, used to crawl websites and extract structured data from their pages";
      homepage = http://scrapy.org/;
      license = licenses.bsd3;
      maintainers = with maintainers; [ drewkett ];
      platforms = platforms.linux;
    };
}
