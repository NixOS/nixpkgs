{ lib
, buildPythonPackage
, isPy3k
, fetchPypi
, setuptools-scm
, setuptools
, requests
, lxml
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "snscrape";
  version = "0.3.4";

  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "36ba7f95c8bf5202749189f760e591952f19c849379c35ff598aafafe5d0cfef";
  };

  # There are no tests; make sure the executable works.
  checkPhase = ''
    export PATH=$PATH:$out/bin
    snscrape --help
  '';

  nativeBuildInputs = [ setuptools-scm ];
  propagatedBuildInputs = [ setuptools requests lxml beautifulsoup4 ];

  meta = with lib; {
    homepage = "https://github.com/JustAnotherArchivist/snscrape";
    description = "A social networking service scraper in Python";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ivan ];
  };
}
