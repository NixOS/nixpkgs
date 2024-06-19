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
    sha256 = "1qjrabl6qr7i6yj6v647ck92abcyklb0vmb6h6kj7x8v2cj5xbvk";
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
    description = "A tile server for rendered geographic data";
    homepage = "http://tilestache.org";
    license = licenses.bsd3;
  };
}
