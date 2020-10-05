{ lib, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "scour";
  version = "0.38.1.post1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "81b93dcfc57338f1260db4fb62697b653770a8a8bd756dcba3640c9b558a7145";
  };

  propagatedBuildInputs = [ six ];

  # No tests included in archive
  doCheck = false;

  meta = with lib; {
    description = "An SVG Optimizer / Cleaner ";
    homepage    = "https://github.com/scour-project/scour";
    license     = licenses.asl20;
    maintainers = with maintainers; [ worldofpeace ];
  };
}
