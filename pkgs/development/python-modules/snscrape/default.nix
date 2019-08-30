{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, setuptools_scm
, requests
, lxml
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "snscrape";
  version = "0.3.0";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f3lyq06l8s4kcsmwbxcwcxnv6mvz9c3zj70np8vnx149p3zi983";
  };

  # There are no tests; make sure the executable works.
  checkPhase = ''
    export PATH=$PATH:$out/bin
    snscrape --help
  '';

  nativeBuildInputs = [ setuptools_scm ];
  propagatedBuildInputs = [ requests lxml beautifulsoup4 ];

  meta = with lib; {
    homepage = https://github.com/JustAnotherArchivist/snscrape;
    description = "A social networking service scraper in Python";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ivan ];
  };
}
