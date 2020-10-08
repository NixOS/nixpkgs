{ stdenv
, buildPythonPackage
, fetchPypi
, six
}:

buildPythonPackage rec {
  pname = "Twiggy";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "259ae96cb22e80c49e75c37dc2f7497028c5dc19018958f05fa00ec08fc2569f";
  };

  propagatedBuildInputs = [ six ];
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = "http://twiggy.wearpants.org";
    # Taken from http://i.wearpants.org/blog/meet-twiggy/
    description = "Twiggy is the first totally new design for a logger since log4j";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ pierron ];
  };

}
