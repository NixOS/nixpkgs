{ stdenv
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  version = "0.62";
  pname = "web.py";
  disabled = isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "5ce684caa240654cae5950da8b4b7bc178812031e08f990518d072bd44ab525e";
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
