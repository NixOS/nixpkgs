{ buildPythonPackage
, isPyPy
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zodbpickle";
  version = "2.6";
  disabled = isPyPy; # https://github.com/zopefoundation/zodbpickle/issues/10

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-BZePwk/5PzSQRa6hH6OtHvqA6rGcq2JR6sdBfGMRodI=";
  };

  # fails..
  doCheck = false;

  meta = {
    homepage = "https://pypi.python.org/pypi/zodbpickle";
  };
}
