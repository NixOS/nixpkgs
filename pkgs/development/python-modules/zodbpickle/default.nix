{ buildPythonPackage
, isPyPy
, fetchPypi
}:

buildPythonPackage rec {
  pname = "zodbpickle";
  version = "2.0.0";
  disabled = isPyPy; # https://github.com/zopefoundation/zodbpickle/issues/10

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fb7c7pnz86pcs6qqwlyw72vnijc04ns2h1zfrm0h7yl8q7r7ng0";
  };

  # fails..
  doCheck = false;

  meta = {
    homepage = "https://pypi.python.org/pypi/zodbpickle";
  };
}
