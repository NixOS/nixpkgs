{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, canonicaljson
, unpaddedbase64
, pynacl
, typing
, typing-extensions
}:

buildPythonPackage rec {
  pname = "signedjson";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "matrix-org";
    repo = "python-signedjson";
    rev = "v${version}";
    sha256 = "18s388hm3babnvakbbgfqk0jzq25nnznvhygywd3azp9b4yzmd5c";
  };

  propagatedBuildInputs = [ canonicaljson unpaddedbase64 pynacl typing-extensions ]
    ++ lib.optionals (pythonOlder "3.5") [ typing ];

  meta = with stdenv.lib; {
    homepage = "https://pypi.org/project/signedjson/";
    description = "Sign JSON with Ed25519 signatures";
    license = licenses.asl20;
  };
}
