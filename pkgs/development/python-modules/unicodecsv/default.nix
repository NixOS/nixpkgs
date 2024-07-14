{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  version = "0.14.1";
  format = "setuptools";
  pname = "unicodecsv";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-AYwIA31IZJoEEgY/9O2ibqqB7/FUbb/6UfpSkydv9/w=";
  };

  # ImportError: No module named runtests
  doCheck = false;

  meta = with lib; {
    description = "Drop-in replacement for Python2's stdlib csv module, with unicode support";
    homepage = "https://github.com/jdunck/python-unicodecsv";
    maintainers = with maintainers; [ koral ];
  };
}
