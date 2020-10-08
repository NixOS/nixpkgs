{ lib, buildPythonPackage, fetchPypi, six }:

buildPythonPackage rec {
  pname = "scour";
  version = "0.38";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cf50a13dcdf8cfe1861f0ce334f413604e376a7681c5b181e15322f43c3befcd";
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
