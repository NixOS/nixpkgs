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

  meta = with lib; {
    homepage = "http://urlgrabber.baseurl.org";
    license = licenses.lgpl2Plus;
    description = "Python module for downloading files";
    mainProgram = "urlgrabber";
    maintainers = with maintainers; [ qknight ];
  };
}
