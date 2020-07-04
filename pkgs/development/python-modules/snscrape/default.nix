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
  version = "0.3.2";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ea038827afe439577eb109ebd1b5c481d516d489c624fc3fe6e92ec71ef42be9";
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
