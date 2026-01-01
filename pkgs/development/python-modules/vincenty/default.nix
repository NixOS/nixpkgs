{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "vincenty";
  version = "0.1.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "maurycyp";
    repo = "vincenty";
    rev = version;
    sha256 = "1li8gv0zb1pdbxdybgaykm38lqbkb5dr7rph6zs1k4k3sh15ldw3";
  };

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "vincenty" ];

<<<<<<< HEAD
  meta = {
    description = "Calculate the geographical distance between 2 points with extreme accuracy";
    homepage = "https://github.com/maurycyp/vincenty";
    license = lib.licenses.unlicense;
    maintainers = with lib.maintainers; [ dotlambda ];
=======
  meta = with lib; {
    description = "Calculate the geographical distance between 2 points with extreme accuracy";
    homepage = "https://github.com/maurycyp/vincenty";
    license = licenses.unlicense;
    maintainers = with maintainers; [ dotlambda ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
