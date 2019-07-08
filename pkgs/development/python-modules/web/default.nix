{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  version = "0.39";
  pname = "web.py";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7e7224493a51f6fbf02f3ce7f2011bcd9e5ebdfce0ee25e5921fdf665ba07542";
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
