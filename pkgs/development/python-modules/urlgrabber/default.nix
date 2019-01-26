{ stdenv, buildPythonPackage, fetchPypi, pycurl, isPy3k }:

buildPythonPackage rec {
  pname = "urlgrabber";
  version = "3.10.2";
  name  = "${pname}-${version}";

  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0w1h7hlsq406bxfy2pn4i9bd003bwl0q9b7p03z3g6yl0d21ddq5";
  };

  propagatedBuildInputs = [ pycurl ];

  meta = with stdenv.lib; {
    homepage = http://urlgrabber.baseurl.org;
    license = licenses.lgpl2Plus;
    description = "Python module for downloading files";
    maintainers = with maintainers; [ qknight ];
  };
}

