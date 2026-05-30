{
  lib,
  buildPythonPackage,
  fetchPypi,
  pycurl,
  six,
}:

buildPythonPackage rec {
  pname = "urlgrabber";
  version = "4.1.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "075af8afabae6362482d254e5ac3ffa595d1766117b684e53d9c25c2e937e139";
  };

  propagatedBuildInputs = [
    pycurl
    six
  ];

  meta = {
    homepage = "http://urlgrabber.baseurl.org";
    license = lib.licenses.lgpl2Plus;
    description = "Python module for downloading files";
    mainProgram = "urlgrabber";
    maintainers = with lib.maintainers; [ qknight ];
  };
}
