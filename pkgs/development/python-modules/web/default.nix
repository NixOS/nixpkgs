{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  version = "0.61";
  pname = "web.py";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c7a9081aeb086cd3e703c7553a47ee75188d1d325f25eec7654d9bb00b5eccbb";
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
    broken = true;
  };

}
