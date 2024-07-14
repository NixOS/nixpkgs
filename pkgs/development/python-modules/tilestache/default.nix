{
  lib,
  buildPythonPackage,
  fetchPypi,
  modestmaps,
  pillow,
  pycairo,
  python-mapnik,
  simplejson,
  werkzeug,
  isPy27,
}:

buildPythonPackage rec {
  pname = "tilestache";
  version = "1.51.14";
  format = "setuptools";
  disabled = !isPy27;

  src = fetchPypi {
    pname = "TileStache";
    inherit version;
    hash = "sha256-c69eJBMb9SOngWbVDRadni0l0mSHmG2kN/FkbOhSWeI=";
  };

  propagatedBuildInputs = [
    modestmaps
    pillow
    pycairo
    python-mapnik
    simplejson
    werkzeug
  ];

  meta = with lib; {
    description = "Tile server for rendered geographic data";
    homepage = "http://tilestache.org";
    license = licenses.bsd3;
  };
}
