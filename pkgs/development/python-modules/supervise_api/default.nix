{ lib
, buildPythonPackage
, fetchPypi
, supervise
, isPy3k
, whichcraft
}:

buildPythonPackage rec {
  pname = "supervise_api";
  version = "0.3.0";

  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "13gy2m14zh6lbdm45b40ffjnw8y3dapz9hvzpwk8vyvbxj4f1vaf";
  };

  propagatedBuildInputs = [
    supervise
  ] ++ lib.optionals ( !isPy3k ) [
    whichcraft
  ];

  # no tests
  doCheck = false;

  meta = {
    description = "An API for running processes safely and securely";
    homepage = https://github.com/catern/supervise;
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ catern ];
  };
}
