{
  lib,
  buildPythonPackage,
  fetchPypi,
  six,
}:

buildPythonPackage rec {
  pname = "twiggy";
  version = "0.5.1";

  src = fetchPypi {
    pname = "Twiggy";
    inherit version;
    hash = "sha256-eTiEAnWXL2zomZSlvfsLhPA4YwGgQ6lgr2NklS54/+Q=";
  };

  propagatedBuildInputs = [ six ];
  doCheck = false;

  meta = with lib; {
    homepage = "http://twiggy.wearpants.org";
    # Taken from http://i.wearpants.org/blog/meet-twiggy/
    description = "Twiggy is the first totally new design for a logger since log4j";
    license = licenses.bsd3;
    maintainers = with maintainers; [ pierron ];
  };
}
