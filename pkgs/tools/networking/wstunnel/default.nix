{ mkDerivation, async, base, base64-bytestring, binary, bytestring
, classy-prelude, cmdargs, connection, hslogger, mtl, network
, network-conduit-tls, stdenv, streaming-commons, text
, unordered-containers, websockets
, lib, fetchFromGitHub, fetchpatch
}:

mkDerivation rec {
  pname = "wstunnel";
  version = "unstable-2019-01-28";

  src = fetchFromGitHub {
    owner = "erebe";
    repo = pname;
    rev = "78cc5a5f1aa4dbcb25fa9b0efc9cfef3640672e4";
    sha256 = "17y3yn7qg1h7jx9xs041sw63g51vyns236f60d2m2mghi49lm9i2";
  };

  patches = [
    # Support GHC 8.6   https://github.com/erebe/wstunnel/pull/18
    (fetchpatch {
      url = "https://github.com/erebe/wstunnel/commit/8f348fea4dbf75874d5d930334377843763335ab.patch";
      sha256 = "0a66jx7k97j3iyr7j5npbyq1lkhzz74r81mkas4nig7z3hny1gn9";
    })
  ];

  isLibrary = false;
  isExecutable = true;

  libraryHaskellDepends = [
    async base base64-bytestring binary bytestring classy-prelude
    connection hslogger mtl network network-conduit-tls
    streaming-commons text unordered-containers websockets
  ];

  executableHaskellDepends = [
    base bytestring classy-prelude cmdargs hslogger text
  ];

  testHaskellDepends = [ base text ];

  homepage = "https://github.com/erebe/wstunnel";
  description = "UDP and TCP tunnelling over WebSocket";
  maintainers = with lib.maintainers; [ gebner ];
  license = lib.licenses.bsd3;

}
