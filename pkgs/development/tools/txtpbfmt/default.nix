{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "txtpbfmt";
  version = "unstable-2023-03-28";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "txtpbfmt";
    rev = "3462fbc510c07c0844c2e370719c9c18302f476f";
    hash = "sha256-vvkZWDGrId164K6jhMXNa5BtOxQSgFDhMACGAH+9F08=";
  };

  vendorHash = "sha256-IdD+R8plU4/e9fQaGSM5hJxyMECb6hED0Qg8afwHKbY=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Formatter for text proto files";
    homepage = "https://github.com/protocolbuffers/txtpbfmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
  };
}
