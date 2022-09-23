{ buildPythonPackage, lib, fetchPypi, glibcLocales, isPy3k, contextvars
, pythonOlder, pytest, curio
}:

buildPythonPackage rec {
  pname = "sniffio";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c4666eecec1d3f50960c6bdf61ab7bc350648da6c126e3cf6898d8cd4ddcd3de";
  };

  disabled = !isPy3k;

  buildInputs = [ glibcLocales ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.7") [ contextvars ];

  checkInputs = [ pytest curio ];

  checkPhase = ''
    pytest
  '';

  meta = with lib; {
    homepage = "https://github.com/python-trio/sniffio";
    license = licenses.asl20;
    description = "Sniff out which async library your code is running under";
  };
}
