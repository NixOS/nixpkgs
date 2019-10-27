{ stdenv
, buildPythonPackage
, fetchgit
, canonicaljson
, unpaddedbase64
, pynacl
}:

buildPythonPackage rec {
  pname = "signedjson";
  version = "1.0.0";

  src = fetchgit {
    url = "https://github.com/matrix-org/python-signedjson.git";
    rev = "refs/tags/v${version}";
    sha256 = "0b8xxhc3npd4567kqapfp4gs7m0h057xam3an7424az262ind82n";
  };

  propagatedBuildInputs = [ canonicaljson unpaddedbase64 pynacl ];

  meta = with stdenv.lib; {
    homepage = https://pypi.org/project/signedjson/;
    description = "Sign JSON with Ed25519 signatures";
    license = licenses.asl20;
  };
}
