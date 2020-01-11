{ buildPythonPackage, lib, fetchPypi, glibcLocales, isPy3k, contextvars
, pythonOlder, pytest, curio
}:

buildPythonPackage rec {
  pname = "sniffio";
  version = "1.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8e3810100f69fe0edd463d02ad407112542a11ffdc29f67db2bf3771afb87a21";
  };

  disabled = !isPy3k;

  buildInputs = [ glibcLocales ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.7") [ contextvars ];

  checkInputs = [ pytest curio ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = https://github.com/python-trio/sniffio;
    license = licenses.asl20;
    description = "Sniff out which async library your code is running under";
  };
}
