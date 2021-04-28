{ lib
, buildPythonPackage
, fetchFromGitHub
, canonicaljson
, unpaddedbase64
, pynacl
, typing-extensions
}:

buildPythonPackage rec {
  pname = "signedjson";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "0y5c9v4vx9hqpnca892gc9b4xgs4gp5xk6l1wma5ciz8zswp9yfs";
  };

  propagatedBuildInputs = [ canonicaljson unpaddedbase64 pynacl typing-extensions ];

  meta = with lib; {
    homepage = "https://pypi.org/project/signedjson/";
    description = "Sign JSON with Ed25519 signatures";
    license = licenses.asl20;
  };
}
