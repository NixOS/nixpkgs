{ buildPythonPackage, lib, fetchPypi, glibcLocales, isPy3k, contextvars
, pythonOlder, pytest, curio
}:

buildPythonPackage rec {
  pname = "sniffio";
  version = "1.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-5gMFxeXTFPU4klm38iqqM9j33uSXYxGSNK83VcVbkQE=";
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
