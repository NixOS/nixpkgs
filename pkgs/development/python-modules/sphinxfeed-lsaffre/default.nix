{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  feedgen,
  python-dateutil,
  sphinx,
}:
buildPythonPackage rec {
  pname = "sphinxfeed-lsaffre";
  version = "0.3.5";
  pyproject = true;

  src = fetchPypi {
    pname = "sphinxfeed_lsaffre";
    inherit version;
    hash = "sha256-uwyAugA4JEkrheJ40CmZThqf/DZbSTBImZHIJeO3SLA=";
  };

  build-system = [ hatchling ];

  propagatedBuildInputs = [
    feedgen
    python-dateutil
    sphinx
  ];

  meta = {
    description = "Sphinx extension for generating RSS feeds";
    homepage = "https://github.com/lsaffre/sphinxfeed";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ MysteryBlokHed ];
  };
}
