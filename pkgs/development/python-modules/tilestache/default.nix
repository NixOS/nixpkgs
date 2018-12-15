{ stdenv
, buildPythonPackage
, fetchPypi
, modestmaps
, pillow
, pycairo
, python-mapnik
, simplejson
, werkzeug
, isPy27
}:

buildPythonPackage rec {
  pname = "tilestache";
  version = "1.50.1";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1z1j35pz77lhhjdn69sq5rmz62b5m444507d8zjnp0in5xqaj6rj";
  };

  propagatedBuildInputs = [ modestmaps pillow pycairo python-mapnik simplejson werkzeug ];

  meta = with stdenv.lib; {
    description = "A tile server for rendered geographic data";
    homepage = http://tilestache.org;
    license = licenses.bsd3;
  };

}
