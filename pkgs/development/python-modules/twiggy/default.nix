{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Twiggy";
  version = "0.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4e8f1894e5aee522db6cb245ccbfde3c5d1aa08d31330c7e3af783b0e66eec23";
  };

  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://twiggy.wearpants.org;
    # Taken from http://i.wearpants.org/blog/meet-twiggy/
    description = "Twiggy is the first totally new design for a logger since log4j";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ pierron ];
  };

}
