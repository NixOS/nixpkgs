{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, requests
, lxml
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "snscrape";
  version = "0.2.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "02mlpzkvpl2mv30cknq6ngw02y7gj2614qikq25ncrpg5vb903d9";
  };

  # There are no tests; make sure the executable works.
  checkPhase = ''
    export PATH=$PATH:$out/bin
    snscrape --help
  '';

  propagatedBuildInputs = [ requests lxml beautifulsoup4 ];

  meta = with lib; {
    homepage = https://github.com/JustAnotherArchivist/snscrape;
    description = "A social networking service scraper in Python";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ivan ];
  };
}
