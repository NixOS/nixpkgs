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
    sha256 = "7938840275972f6ce89994a5bdfb0b84f0386301a043a960af6364952e78ffe4";
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
