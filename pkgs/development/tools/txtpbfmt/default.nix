{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule {
  pname = "txtpbfmt";
  version = "0-unstable-2024-04-16";

  src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "txtpbfmt";
    rev = "1e18ef0a7fdc4d28b9223d2d50b4b2be7024519e";
    hash = "sha256-L96aEAlPvdBXxAbH8IszQK0r7ouICmFrkHtTJe/dD+E=";
  };

  vendorHash = "sha256-IdD+R8plU4/e9fQaGSM5hJxyMECb6hED0Qg8afwHKbY=";

  ldflags = [ "-s" "-w" ];

  meta = with lib; {
    description = "Formatter for text proto files";
    homepage = "https://github.com/protocolbuffers/txtpbfmt";
    license = licenses.asl20;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "txtpbfmt";
  };
}
