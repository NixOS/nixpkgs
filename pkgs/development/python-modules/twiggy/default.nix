{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "Twiggy";
  version = "0.4.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "44d8aa51110efaab0712b5ec2b015149ad4f28e28f729004aac45d0ad8e19be0";
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
