{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  version = "0.51";
  pname = "web.py";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "b50343941360984d37270186453bb897d13630028a739394fedf38f9cde2fd07";
  };

  meta = with stdenv.lib; {
    description = "Makes web apps";
    longDescription = ''
      Think about the ideal way to write a web app.
      Write the code to make it happen.
    '';
    homepage = "https://webpy.org/";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ layus ];
  };

}
