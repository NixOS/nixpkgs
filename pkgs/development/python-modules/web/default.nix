{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  version = "0.37";
  pname = "web.py";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "748c7e99ad9e36f62ea19f7965eb7dd7860b530e8f563ed60ce3e53e7409a550";
  };

  meta = with stdenv.lib; {
    description = "Makes web apps";
    longDescription = ''
      Think about the ideal way to write a web app.
      Write the code to make it happen.
    '';
    homepage = "http://webpy.org/";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ layus ];
  };

}
