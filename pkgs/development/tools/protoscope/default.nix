{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "protoscope";
  version = "unstable-2022-10-04";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protoscope";
    rev = "8b1d63939ee1a5d922b38f3976e1e58cae525163";
    sha256 = "sha256-/vt02rvKVsryJZ+Bw4QLaGzDErGI04/4NUbSBkbbN3Y=";
  };

  vendorSha256 = "sha256-mK8eGo6oembs4nofvROn4g0+oO5E5/zQrmPKMe3xXik=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Simple, human-editable language for representing and emitting the Protobuf wire format";
    homepage = "https://github.com/protocolbuffers/protoscope";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
