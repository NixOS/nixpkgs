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
    hash = "sha256-B1r4r6uuY2JILSVOWsP/pZXRdmEXtoTlPZwlwuk34Tk=";
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
