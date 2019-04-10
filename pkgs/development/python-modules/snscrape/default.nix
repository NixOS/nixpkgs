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
  version = "0.1.3";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1mnhqqc7xfwg2wrzpj1pjbcisjjwxrgmy21f53p80xbx2iz8b9n1";
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
