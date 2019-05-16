{ buildPythonPackage, lib, fetchPypi, glibcLocales, isPy3k, contextvars
, pythonOlder
}:

buildPythonPackage rec {
  pname = "sniffio";
  version = "1.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1dzb0nx3m1hpjgsv6s6w5ac2jcmywcz6gqnfkw8rwz1vkr1836rf";
  };

  # breaks with the following error:
  # > TypeError: 'encoding' is an invalid keyword argument for this function
  disabled = !isPy3k;

  buildInputs = [ glibcLocales ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.7") [ contextvars ];

  # no tests distributed with PyPI
  doCheck = false;

  meta = with lib; {
    homepage = https://github.com/python-trio/sniffio;
    license = licenses.asl20;
    description = "Sniff out which async library your code is running under";
  };
}
