{ lib
, buildPythonPackage
, fetchPypi
, supervise
}:

buildPythonPackage rec {
  pname = "supervise_api";
  version = "0.1.5";

  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1pqqlw80cjdgrlpvdmydkyhsrr4s531mn6bfkshm68j9gk4kq6px";
  };

  propagatedBuildInputs = [ supervise ];

  # no tests
  doCheck = false;

  meta = {
    description = "An API for running processes safely and securely";
    homepage = https://github.com/catern/supervise;
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ catern ];
  };
}
