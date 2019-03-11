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
  version = "1.51.13";
  disabled = !isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "11e15dd85501345bcfeb18dce5b1c8fb74ac8d867df2520afe0eefe1edd85f27";
  };

  propagatedBuildInputs = [ modestmaps pillow pycairo python-mapnik simplejson werkzeug ];

  meta = with stdenv.lib; {
    description = "A tile server for rendered geographic data";
    homepage = http://tilestache.org;
    license = licenses.bsd3;
  };

}
