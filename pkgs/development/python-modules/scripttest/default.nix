{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
}:

buildPythonPackage rec {
  pname = "scripttest";
  version = "1.3";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lRz8JSGbDNADSTpWXy5iH9eRvqrp+aO91wJNhiZBnDg=";
  };

  buildInputs = [ pytest ];

  # Tests are not included. See https://github.com/pypa/scripttest/issues/11
  doCheck = false;

  meta = with lib; {
    description = "Library for testing interactive command-line applications";
    homepage = "https://pypi.org/project/scripttest/";
    maintainers = with maintainers; [ ];
    license = licenses.mit;
  };
}
