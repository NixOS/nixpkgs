{ lib, buildPythonPackage, fetchPypi, numpy, nose, pyyaml }:

buildPythonPackage rec {
  pname = "spglib";
  version = "1.16.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Lqzv1TzGRLqakMRoH9bJNLa92BjBE9fzGZBOB41dq5M=";
  };

  propagatedBuildInputs = [ numpy ];

  checkInputs = [ nose pyyaml ];

  meta = with lib; {
    description = "Python bindings for C library for finding and handling crystal symmetries";
    homepage = "https://atztogo.github.io/spglib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ psyanticy ];
  };
}

