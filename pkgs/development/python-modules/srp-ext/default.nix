{ lib, fetchPypi, buildPythonPackage, six, openssl }:

buildPythonPackage rec {
  pname = "srp-ext";
  version = "1.0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06r1s1fq1phx41k740dkdgjda695zy6yd55v0dw1kmrb4vvazh1l";
  };

  buildInputs = [ six openssl ];

  doCheck = false;

  meta = {
    homepage = https://github.com/capless/warrant;
    description = "secure remote password";
    maintainers = with lib.maintainers; [ mog ];
    license = lib.licenses.mit;
  };
}
