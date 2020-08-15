{ stdenv
, buildPythonPackage
, fetchPypi
, cheroot
}:

buildPythonPackage rec {
  version = "0.61";
  pname = "web.py";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fycbq5v16sdcp3yw9az68fqs63mxr3klmf70gkx6v08xcd0iaf7";
  };

  propagatedBuildInputs = [ cheroot ];

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
