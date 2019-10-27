{ stdenv, buildPythonPackage, fetchPypi, pycurl, six }:

buildPythonPackage rec {
  pname = "urlgrabber";
  version = "4.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0fazs574fgixd525cn2dh027f4qf0c0gbwcfyfkhc6fkblfa1ibr";
  };

  propagatedBuildInputs = [ pycurl six ];

  meta = with stdenv.lib; {
    homepage = http://urlgrabber.baseurl.org;
    license = licenses.lgpl2Plus;
    description = "Python module for downloading files";
    maintainers = with maintainers; [ qknight ];
  };
}
