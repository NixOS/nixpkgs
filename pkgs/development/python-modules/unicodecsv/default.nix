{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  version = "0.14.1";
  pname = "unicodecsv";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    sha256 = "1z7pdwkr6lpsa7xbyvaly7pq3akflbnz8gq62829lr28gl1hi301";
  };

  build-system = [ setuptools ];

  # ImportError: No module named runtests
  doCheck = false;

  meta = {
    description = "Drop-in replacement for Python2's stdlib csv module, with unicode support";
    homepage = "https://github.com/jdunck/python-unicodecsv";
    maintainers = with lib.maintainers; [ koral ];
    license = lib.licenses.bsd2WithViews;
  };
})
