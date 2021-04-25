{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protobuf-go";
  version = "1.26.0";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf-go";
    rev = "v${version}";
    sha256 = "sha256:0xq6phaps6d0vcv13ga59gzj4306l0ki9kikhmb52h6pq0iwfqlz";
  };

  vendorSha256 = "sha256:0rhgx3zkxp9gg4q7vck6x0ps5fp67lc0swbrgbpsghhribi2bgy9";

  meta = with lib; {
    homepage    = "https://developers.google.com/protocol-buffers";
    description = "Go support for Protocol Buffers";
    maintainers = with maintainers; [ raboof ];
    license     = licenses.bsd3;
    platforms   = platforms.unix;
  };
}
