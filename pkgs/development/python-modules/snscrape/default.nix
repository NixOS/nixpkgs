{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, setuptools_scm
, setuptools
, requests
, lxml
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "snscrape";
  version = "0.3.1";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "11jv5mv3l11qjlsjihd74gc1jafq0i7360cksqjkx1wv2hcc32rf";
  };

  # There are no tests; make sure the executable works.
  checkPhase = ''
    export PATH=$PATH:$out/bin
    snscrape --help
  '';

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ setuptools requests lxml beautifulsoup4 ];

  meta = with lib; {
    homepage = "https://github.com/JustAnotherArchivist/snscrape";
    description = "A social networking service scraper in Python";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ivan ];
  };
}
