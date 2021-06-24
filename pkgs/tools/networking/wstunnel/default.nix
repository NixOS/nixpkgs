{ mkDerivation, async, base, base64-bytestring, binary, bytestring
, classy-prelude, cmdargs, connection, hslogger, mtl, network
, network-conduit-tls, streaming-commons, text
, unordered-containers, websockets
, hspec, iproute
, lib, fetchFromGitHub, fetchpatch
}:

mkDerivation rec {
  pname = "wstunnel";
  version = "unstable-2020-07-12";

  src = fetchFromGitHub {
    owner = "erebe";
    repo = pname;
    rev = "093a01fa3a34eee5efd8f827900e64eab9d16c05";
    sha256 = "17p9kq0ssz05qzl6fyi5a5fjbpn4bxkkwibb9si3fhzrxc508b59";
  };

  isLibrary = false;
  isExecutable = true;

  libraryHaskellDepends = [
    async base base64-bytestring binary bytestring classy-prelude
    connection hslogger mtl network network-conduit-tls
    streaming-commons text unordered-containers websockets
    iproute
  ];

  executableHaskellDepends = [
    base bytestring classy-prelude cmdargs hslogger text
  ];

  testHaskellDepends = [ base text hspec ];

  homepage = "https://github.com/erebe/wstunnel";
  description = "UDP and TCP tunnelling over WebSocket";
  maintainers = with lib.maintainers; [ gebner ];
  license = lib.licenses.bsd3;

}
